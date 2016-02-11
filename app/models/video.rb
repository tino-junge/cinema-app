class Video
  attr_reader :name
  attr_reader :stream
  attr_reader :sequels
  attr_reader :question
  attr_reader :answers

  def initialize(name, file)
    @name = name

    if file.nil?
      abort("Node #{@name}: No video file!'")
    end
    path = Pathname.new(ActiveCinema::App.settings.root).join("public").join("videos").join(file)
    unless File.exists?(path)
      abort("Node #{@name}: No corresponding file in '#{path}'")
    end

    @stream = ENV['RACK_ENV'] == "production" ? ActiveCinema::App.settings.remote_url + file + "&download" : "videos/" + file
  end

  def connect(question, answers, sequels)
    @question = question
    @answers  = answers
    @sequels  = sequels

    if @answers.nil?
      abort("id #{@name}")
    end
    @answers.keys.each do |answer_key|
      unless @sequels.keys.include?(answer_key)
        abort("Node #{name}: Missing sequel for answer '#{answer_key}'.")
      end
    end

    @sequels.each do |answer_key, sequel_video|
      if sequel_video.nil?
        abort("Node #{name}: Couldn't find a sequel node for answer '#{answer_key}'.")
      end
    end

  end

end
