# frozen_string_literal: true

require_relative 'game'

Game.start((ARGV.first || '10').to_i)
