# frozen_string_literal: true

class GameElement
  attr_reader :position, :name

  def initialize(initial_position, name)
    @position = initial_position
    @name = name
  end
end
