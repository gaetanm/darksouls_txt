# frozen_string_literal: true

require_relative 'engine/game'

Game.start((ARGV.first || '10').to_i)
