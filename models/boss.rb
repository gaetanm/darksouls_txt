# frozen_string_literal: true

require_relative 'game_element'

class Boss < GameElement
  attr_accessor :discovered

  def initialize(initial_position, name = 'Artorias')
    super(initial_position, name)
    @discovered = false
  end
end
