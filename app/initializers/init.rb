module ActiveCinema
  def self.the_video
    @video ||= nil
  end

  def self.start_with(video)
    @video = video
  end

  class App < Sinatra::Application
    video_3a = Video.new('V03a', settings.video_url['V03a'])
    video_3b = Video.new('V03b', settings.video_url['V03b'])
    video_3 = Video.new(
      'V03',
      settings.video_url['V03'],
      [video_3a, video_3b],
      settings.question['Q03'],
      [settings.answer['A03a'], settings.answer['A03b']])

    ActiveCinema.start_with(video_3)
  end
end
