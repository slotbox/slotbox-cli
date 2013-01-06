require "addressable/uri"

module Heroku::Command

  # deploy the app from its Github repo
  class Deploy < BaseWithApp

    def index
      # Pick the first 
      remote = git "config --get remote.origin.url"
      if remote.nil? || !remote.include?("github.com")
        raise(CommandFailed, "A Github repo must be in a remote called 'origin'")
      end
      # Ensure that we have a non-SSH version of the repo, so we don't have to 
      # 'ensure the authenticity of the host' when pulling.
      # Note that only Addressable::URI seems to be able to handle ssh-style URIs
      path = Addressable::URI.parse(remote).path.split('/')
      remote = "https://github.com/#{path[-2]}/#{path[-1]}"

      app = git "config --get slotbox.app"
      if app.nil?
        raise(CommandFailed, "Cannot find Slotbox app name from git config")
      end

      process_data = action("Starting deploy", :success => "connected") do
        process_data = api.put_app_deploy(app, remote).body
        status(process_data["process"])
        process_data
      end
      rendezvous_session(process_data["rendezvous_url"])
    end

    protected
      def rendezvous_session(rendezvous_url, &on_connect)
        begin
          set_buffer(false)
          rendezvous = Heroku::Client::Rendezvous.new(
            :rendezvous_url => rendezvous_url,
            :connect_timeout => (ENV["HEROKU_CONNECT_TIMEOUT"] || 120).to_i,
            :activity_timeout => nil,
            :input => nil,
            :output => $stdout)
          rendezvous.on_connect(&on_connect)
          rendezvous.start
        rescue Timeout::Error
          error "\nTimeout awaiting process"
        rescue OpenSSL::SSL::SSLError
          error "Authentication error"
        rescue Errno::ECONNREFUSED, Errno::ECONNRESET
          error "\nError connecting to process"
        rescue Interrupt
        ensure
          set_buffer(true)
        end
      end

  end
end