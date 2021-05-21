# frozen_string_literal: true

class Room
  attr_accessor :around_rooms_positions, :visited
  attr_reader :id, :position

  def initialize(id, position)
    @id = id
    @position = position
    @visited = id.zero?
    @around_rooms_positions = []
  end
end
