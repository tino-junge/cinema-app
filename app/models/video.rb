class Video
  attr_reader :name
  attr_reader :stream
  attr_reader :sequels
  attr_reader :question
  attr_reader :answers

  def initialize(name, stream, sequels = nil, question = nil, answers = nil)
    @name     = name
    @stream   = stream
    @sequels  = sequels
    @question = question
    @answers  = answers
  end

end
