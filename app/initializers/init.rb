module ActiveCinema
  def self.the_video
    @video ||= nil
  end

  def self.start_with(video)
    @video = video
  end

  class App < Sinatra::Application
    video_a = Video.new('test03A', settings.video_url['test_03a'], [])
    video_b = Video.new('test03B', settings.video_url['test_03b'], [])
    video = Video.new('test03', settings.video_url['test_03'], [video_a, video_b])

    ActiveCinema.start_with(video)
  end
end
