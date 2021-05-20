# frozen_string_literal: true

require 'readline'
require_relative 'dungeon'
require_relative 'map'
require_relative 'boss'
require_relative 'player'
require_relative 'weapon'

class Game
  ROOMS_NBR = 20
  MOVING_INPUT = %w[right left top bottom].freeze

  def initialize
    @dungeon = Dungeon.new(ROOMS_NBR)
    @player = Player.new(@dungeon.first_room_position.clone, 'Undead')
    @weapon = Weapon.new(@dungeon.random_room_position([@player.position]).clone)
    @boss = Boss.new(@dungeon.random_room_position([@player.position, @weapon.position].clone))
    @map = Map.new(@dungeon, @player.position, @boss.position, @weapon.position, :debug)
    @possible_choices = possible_directions
    @instruction = "Where to go? (#{@possible_choices.join('/')})"
    @screen = @map.draw
  end

  def calculate_directions(current_position, position)
    if position.x == current_position.x + 1 && position.y == current_position.y
      'right'
    elsif position.x == current_position.x - 1 && position.y == current_position.y
      'left'
    elsif position.y == current_position.y + 1 && position.x == current_position.x
      'top'
    else
      'bottom'
    end
  end

  def possible_directions
    possible_directions = []
    current_room = @dungeon.room_from_position(@player.position)
    current_room.around_rooms_positions.each do |position|
      possible_directions << calculate_directions(current_room.position, position)
    end
    possible_directions
  end

  def handle_input(input)
    if MOVING_INPUT.include? input
      handle_moving(input)
    end
  end

  def start
    system("clear") || system("cls")
    while input = Readline.readline("#{@screen}\n#{@instruction} ", true)
      break if input == 'exit'

      system("clear") || system("cls")
      handle_input(input) if @possible_choices.include?(input)
    end
  end

  def refresh_screen
    @screen = @map.draw
  end

  def handle_moving(input)
    @player.walk(input)
    @dungeon.mark_room_as_visited(@player.position)
    refresh_screen
    @possible_choices = possible_directions
    @instruction = "Where to go? (#{@possible_choices.join('/')})"
  end
end
