module Heroku::Command

  # deploy the app from its Github repo
  class Deploy < BaseWithApp

    def index
      # Pick the first 
      remote = git "config --get remote.origin.url"
      if remote.nil? || !remote.include?("github.com")
        raise(CommandFailed, "A Github repo must be in a remote called 'origin'")
      end
      app = git "config --get slotbox.app"
      if app.nil?
        raise(CommandFailed, "Cannot find Slotbox app name from git config")
      end
      display api.put_app_deploy(app, remote).body
    end

  end
end