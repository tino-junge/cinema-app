module ActiveCinema
  class App < Sinatra::Application

    get '/', agent: /(android|bb\d+|meego).+mobile|avantgo|bada\/|blackberry|blazer|compal|elaine|fennec|hiptop|iemobile|ip(hone|od)|iris|kindle|lge |maemo|midp|mmp|mobile.+firefox|netfront|opera m(ob|in)i|palm( os)?|phone|p(ixi|re)\/|plucker|pocket|psp|series(4|6)0|symbian|treo|up\.(browser|link)|vodafone|wap|windows ce|xda|xiino/i do
      redirect to('/voting')
    end

    get "/" do
      slim :index
    end

    get "/movie" do
      @video = ActiveCinema.the_video
      slim :movie
    end

    get "/voting" do
      @video = ActiveCinema.the_video
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
