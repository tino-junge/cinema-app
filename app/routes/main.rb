module ActiveCinema
  class App < Sinatra::Application

    video_a = Video.new('test03A', settings.video_url['test_03a'], [])
    video_b = Video.new('test03B', settings.video_url['test_03b'], [])
    video = Video.new('test03', settings.video_url['test_03'], [video_a, video_b])
    @video = video

    get "/" do
      slim :index
    end

    get "/js/application.js" do
      content_type :js
      @scheme = ENV['RACK_ENV'] == "production" ? "wss://" : "ws://"
      # Only Testing
      # @video_link_a = settings.video_url["test_03a"]
      # @video_link_b = settings.video_url["test_03b"]
      erb :"application.js"
    end

    get "/voting" do
      slim :voting
    end

    get "/movie" do
      # @video_link = settings.video_url["test_03"]
      p @video
      slim :movie
    end
  end
end