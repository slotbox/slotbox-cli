# Here we disbale the ability to manually name apps
# And remove other functionality not present in Slotbox

class Heroku::Command::Apps

  # apps:create
  #
  # create a new app
  #
  #     --addons ADDONS        # a comma-delimited list of addons to install
  # -b, --buildpack BUILDPACK  # a buildpack url to use for this app
  # -r, --remote REMOTE        # the git remote to create, first github.com is default
  #
  #Examples:
  #
  # $ heroku apps:create
  # Creating slotbox-nodejs-hello-world... done, stack is cedar
  # http://slotbox-nodejs-hello-world.slotbox.es/
  #
  def create
    name    = app
    validate_arguments!

    info    = api.post_app({
      "name" => name,
      "region" => options[:region]
    }).body
    begin
      action("Creating #{info['name']}") do
        if info['create_status'] == 'creating'
          Timeout::timeout(options[:timeout].to_i) do
            loop do
              break if api.get_app(info['name']).body['create_status'] == 'complete'
              sleep 1
            end
          end
        end
        status("stack is #{info['stack']}")
      end

      (options[:addons] || "").split(",").each do |addon|
        addon.strip!
        action("Adding #{addon} to #{info["name"]}") do
          api.post_addon(info["name"], addon)
        end
      end

      if buildpack = options[:buildpack]
        api.put_config_vars(info["name"], "BUILDPACK_URL" => buildpack)
        display("BUILDPACK_URL=#{buildpack}")
      end

      hputs(info["web_url"])
    rescue Timeout::Error
      hputs("Timed Out! Run `heroku status` to check for known platform issues.")
    end

  end

  alias_command "create", "apps:create"

end
