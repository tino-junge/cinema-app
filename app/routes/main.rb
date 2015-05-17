module ActiveCinema
  class App < Sinatra::Application
    get "/" do
      slim :index
    end

    get "/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      # Only Testing
      @video_link_a = settings.video.sequels[0].stream
      @video_link_b = settings.video.sequels[1].stream
      erb :"application.js"
    end

    get "/voting" do
      slim :voting
    end

    get "/movie" do
      @video = settings.video
      slim :movie
    end
  end
end
