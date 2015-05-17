class Video
  attr_reader :name
  attr_reader :stream
  attr_reader :sequels

  def initialize(name, stream, sequels)
    @name = name
    @stream = stream
    @sequels = sequels
  end
end
