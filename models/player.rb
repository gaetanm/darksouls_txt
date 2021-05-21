# frozen_string_literal: true

require_relative 'position'
require_relative 'game_element'

class Player < GameElement
  def fight(weapon_equipped)
    return 'Yay you won!' if weapon_equipped

    rand(2).zero? ? 'YOU DIED!' : 'Yay you won!'
  end

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
    end
  end
end
