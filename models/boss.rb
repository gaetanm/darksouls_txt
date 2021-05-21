# frozen_string_literal: true

require_relative 'game_element'

class Boss < GameElement
  def initialize(initial_position, name = 'Artorias')
    super(initial_position, name)
  end

  def teleport(position)
    @position.x = position.x
    @position.y = position.y
  end
end
