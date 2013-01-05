module Heroku
  class API

    # PUT /apps/:app/deploy
    def put_app_deploy(app, github_url)
      request(
        :expects  => 200,
        :method   => :put,
        :path     => "/apps/#{app}/deploy",
        :query    => app_params({"github_url" => github_url})
      )
    end

  end
end