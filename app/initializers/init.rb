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

    def self.check_video_file_exists(id, file)
      if file.nil?
        abort("Node #{id}: No video file!'")
      end
      path = Pathname.new(settings.root).join("public").join("videos").join(file)
      unless File.exists?(path)
        abort("Node #{id}: No corresponding file in '#{path}'")
      end
    end

    def self.create_video(id, all_videos, possible_loop)
      if possible_loop.include?(id)
        possible_loop << id
        abort("Node #{id}: Detected a loop #{possible_loop.join("->")}")
      else
        possible_loop << id
      end

      video = all_videos.find { |v| v.name == id}
      if video.nil?
        file = settings.video[id]['file']
        check_video_file_exists(id, file)

        sequels = {}
        unless settings.video[id]['sequels'].nil?
          settings.video[id]['sequels'].each do |key, sequel_id|
            # sequel_video is the first return value
            sequel_video = create_video(sequel_id, all_videos, possible_loop).first
            sequels[key] = sequel_video
          end
        end
        possible_loop = []

        video = Video.new(
          id,
          ENV['RACK_ENV'] == "production" ? settings.remote_url + file + "&download" : "videos/" + file,
          sequels,
          settings.video[id]['question'],
          settings.video[id]['answers'])
        all_videos << video
        return video, all_videos
      else
        return video, all_videos
      end
    end

    def self.check_config_file_is_not_empty
      unless settings.respond_to?(:video)
        abort("Configuration file is invalid: Please add a key 'video'.")
      end
    end

    check_config_file_is_not_empty

    # starting video is the first return parameter
    video = create_video('v1', [], []).first

    ActiveCinema.start_with(video)
  end
end
