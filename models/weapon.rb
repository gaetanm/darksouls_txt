# frozen_string_literal: true

require_relative 'game_element'

class Weapon < GameElement
  attr_accessor :equipped

  def initialize(initial_position, name = 'Moonlight Greatsword')
    super(initial_position, name)
    @equipped = false
  end
end
