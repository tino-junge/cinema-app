module ActiveCinema
  class App < Sinatra::Application
    get "/" do
      slim :index
    end

    get "/movie" do
      @video = ActiveCinema.the_video
      slim :movie
    end

    get "/voting" do
      slim :voting
    end

    get "/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      erb :"application.js"
    end

    get "/js/movie.js" do
      content_type :js
      erb :"movie.js"
    end

    get "/js/voting.js" do
      content_type :js
      erb :"voting.js"
    end
  end
end
