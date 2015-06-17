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
    # TODO move to database.yml file
    video_11a = Video.new('V11a', settings.video_url['V11a'])
    video_11b = Video.new('V11b', settings.video_url['V11b'])
    video_10b = Video.new('V10b', settings.video_url['V10b'], [video_11b])
    video_10a3 = Video.new('V10a3', settings.video_url['V10a3'], [video_11a])
    video_10a2 = Video.new(
      'V10a2',
      settings.video_url['V10a2'],
      [video_10a3, video_11b],
      settings.question['Q10'],
      [settings.answer['A10a'], settings.answer['A10b']])
    video_10a1 = Video.new(
      'V10a1',
      settings.video_url['V10a1'],
      [video_10a2, video_10b],
      settings.question['Q10'],
      [settings.answer['A10a'], settings.answer['A10b']])
    video_10 = Video.new(
      'V10',
      settings.video_url['V10'],
      [video_10a1, video_10b],
      settings.question['Q10'],
      [settings.answer['A10a'], settings.answer['A10b']])
    video_6a = Video.new('V06a', settings.video_url['V06a'], [video_10])
    video_6b = Video.new('V06b', settings.video_url['V06b'], [video_10])
    video_6c = Video.new('V06c', settings.video_url['V06c'], [video_10])
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
