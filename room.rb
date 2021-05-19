# frozen_string_literal: true

class Room
  attr_accessor :around_rooms_ids, :visited
  attr_reader :id, :position

  def initialize(id, position)
    @id = id
    @position = position
    @visited = false
    @around_rooms_ids = []
  end
end
