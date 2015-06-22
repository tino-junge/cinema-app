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

  def self.find_by_name(name)
    found = nil
    ObjectSpace.each_object(Video) do |o|
      found = o if o.name == name
    end
    found
  end
end
