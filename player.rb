# frozen_string_literal: true

require_relative 'position'
require_relative 'game_element'

class Player < GameElement
  def walk(direction)
    case direction
    when 'right'
      @position.x = position.x + 1
    when 'left'
      @position.x = position.x - 1
    when 'top'
      @position.y = position.y + 1
    when 'bottom'
      @position.y = position.y - 1
    else
      'woot?'
    end
  end
end
