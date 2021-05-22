# frozen_string_literal: true

require_relative 'game_element'

class Weapon < GameElement
  attr_accessor :equipped, :discovered

  def initialize(initial_position, name = 'Moonlight Greatsword')
    super(initial_position, name)
    @equipped = false
    @discovered = false
  end
end
