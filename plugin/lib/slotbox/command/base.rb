require "addressable/uri"

class Heroku::Command::Base

  def app
    @app ||= if options[:confirm].is_a?(String)
      if options[:app] && (options[:app] != options[:confirm])
        error("Mismatch between --app and --confirm")
      end
      options[:confirm]
    elsif options[:app].is_a?(String)
      options[:app]
    elsif ENV.has_key?('SLOTBOX_APP')
      ENV['SLOTBOX_APP']
    elsif app_from_dir = extract_app_in_dir(Dir.pwd)
      app_from_dir
    else
      # raise instead of using error command to enable rescuing when app is optional
      raise Heroku::Command::CommandFailed.new("No app specified.\nRun this command from an app folder or specify which app to use with --app APP.")
    end
  end

  protected
    def extract_app_in_dir(dir)
      return unless remotes = git_remotes(dir)

      if remote = options[:remote]
        extract_app_name_from_remote remotes[remote]
      elsif remote = extract_app_from_git_config
        extract_app_name_from_remote remotes[remote]
      else
        apps = remotes.values.uniq
        if apps.size == 1
          extract_app_name_from_remote apps.first
        else
          raise(Heroku::Command::CommandFailed, "Multiple apps in folder and no app specified.\nSpecify app with --app APP.")
        end
      end
    end

    def extract_app_from_git_config
      remote = git("config slotbox.remote")
      remote == "" ? nil : remote
    end

    def extract_app_name_from_remote remote
      if !(remote =~ "github.com")
        raise(Heroku::Command::CommandFailed, "You must have a git remote hosted on github.com")
      end
      path = Addressable::URI.parse(remote).path.gsub(/\.git$/, '').split('/')
      "#{path[-2]}-#{path[-1]}"
    end

end