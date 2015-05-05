require 'sinatra/base'
require 'tilt/erb'

module ChatDemo
  class App < Sinatra::Base
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
      erb :"movie.html"
    end
  end
end
