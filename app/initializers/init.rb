module ActiveCinema
  def self.start_video
    @start_video ||= nil
  end

  def self.start_with(video)
    @start_video = video
    set_current(video)
  end

  def self.set_current(video)
    @current_video = video
  end

  def self.the_video
    @current_video ||= nil
  end

  class App < Sinatra::Application
    def self.create_video(id)
      if Video.find_by_name(id).nil?
        file = settings.video[id]['file']
        Video.new(
          id,
          ENV['RACK_ENV'] == "production" ? settings.remote_url + file + "&download" : "videos/" + file,
          sequels_for(id),
          settings.video[id]['question'],
          settings.video[id]['answers'])
      else
        Video.find_by_name(id)
      end
    end

    def self.sequels_for(id)
      sequels = {}
      unless settings.video[id]['sequels'].nil?
        settings.video[id]['sequels'].each do |key, sequel_id|
          sequels[key] = create_video(sequel_id)
        end
      end
      sequels
    end

    video = create_video('v1')

    ActiveCinema.start_with(video)
  end
end
