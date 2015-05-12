require 'sinatra/base'
require 'sinatra/config_file'
require 'tilt/erb'
require 'slim'

module ActiveCinema
  class App < Sinatra::Base
    register Sinatra::ConfigFile
    config_file './config/config.yml'

    get "/" do
      slim :index
    end

    get "/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      erb :"application.js"
    end

    get "/voting" do
      slim :voting
    end

    get "/movie" do
      @video_link = settings.video_url["test_03"]
      slim :movie
    end
  end
end
