# frozen_string_literal: true

require_relative 'game_element'

class Weapon < GameElement
  def initialize(initial_position, name = 'Moonlight Greatsword')
    super(initial_position, name)
  end
end
