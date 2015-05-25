module ActiveCinema
  def self.the_video
    @video ||= nil
  end

  def self.start_with(video)
    @video = video
  end

  class App < Sinatra::Application
    video_6a = Video.new('V06a', settings.video_url['V06a'])
    video_6b = Video.new('V06b', settings.video_url['V06b'])
    video_6c = Video.new('V06c', settings.video_url['V06c'])
    video_6 = Video.new(
      'V06',
      settings.video_url['V06'],
      [video_6a, video_6b, video_6c],
      settings.question['Q06'],
      [settings.answer['A06a'], settings.answer['A06b'], settings.answer['A06c']])
    video_3a = Video.new('V03a', settings.video_url['V03a'], [video_6])
    video_3b = Video.new('V03b', settings.video_url['V03b'], [video_6])
    video_3 = Video.new(
      'V03',
      settings.video_url['V03'],
      [video_3a, video_3b],
      settings.question['Q03'],
      [settings.answer['A03a'], settings.answer['A03b']])

    ActiveCinema.start_with(video_3)
  end
end
