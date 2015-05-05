require 'sinatra/base'
require 'sinatra/config_file'
require 'tilt/erb'

module ActiveCinema
  class App < Sinatra::Base
    register Sinatra::ConfigFile
    config_file './config/config.yml'

    get "/" do
      erb :"index.html"
    end

    get "/assets/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      erb :"application.js"
    end

    get "/app" do
      erb :"app.html"
    end

    get "/movie" do
      @video_link = settings.video_url["test_03"]
      erb :"movie.html"
    end
  end
end
