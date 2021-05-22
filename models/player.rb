# frozen_string_literal: true

require_relative 'position'
require_relative 'game_element'

class Player < GameElement
  def fight(weapon_equipped)
    return true if weapon_equipped

    win_fight_success.zero?
  end

  def run
    run_success.zero? || run_success == 1
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

  private

  def win_fight_success
    rand(2)
  end

  def run_success
    rand(3)
  end
end
