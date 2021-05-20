# frozen_string_literal: true

require 'readline'
require_relative 'dungeon'
require_relative 'map'
require_relative 'boss'
require_relative 'player'
require_relative 'weapon'

class Game
  ROOMS_NBR = 10
  MOVING_INPUT = %w[right left top bottom].freeze
  CHOICE_INPUT = %w[yes no].freeze

  def initialize
    @dungeon = Dungeon.new(ROOMS_NBR)
    @player = Player.new(@dungeon.first_room_position.clone, 'Undead')
    @weapon = Weapon.new(@dungeon.random_room_position([@player.position]).clone)
    @boss = Boss.new(@dungeon.random_room_position([@player.position, @weapon.position].clone))
    @map = Map.new(@dungeon, @player.position, @boss.position, @weapon.position, :debug)
    @possible_choices = possible_directions
    @instruction = "Where to go? (#{@possible_choices.join('/')})"
    @screen = @map.draw
    @action = :moving
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
    if MOVING_INPUT.include?(input) && @action == :moving
      handle_moving(input)
    end
    if CHOICE_INPUT.include?(input) && @action == :equipping
      handle_equipping(input)
    end
  end

  def start
    system("clear") || system("cls")
    while input = Readline.readline("#{@screen}\n#{@instruction} ", true)
      break if input == 'exit'

      system("clear") || system("cls")
      handle_input(input) if @possible_choices.include?(input)
      refresh_screen
    end
  end

  def refresh_screen
    @screen = @map.draw
  end

  def handle_equipping(input)
    if input == 'yes'
      @possible_choices = possible_directions
      @instruction = "You can now kill the boss!\n Where to go? (#{@possible_choices.join('/')})"
    else
      @instruction = "#{@boss.name} will kick your ass for sure!\n Where to go? (#{@possible_choices.join('/')})"
    end
    @action = :moving
    @possible_choices = possible_directions
  end

  def handle_moving(input)
    @player.walk(input)
    return if collision?

    @dungeon.mark_room_as_visited(@player.position)
    @possible_choices = possible_directions
    @instruction = "Where to go? (#{@possible_choices.join('/')})"
  end

  def collision?
    if @player.position == @weapon.position
      @action = :equipping
      @possible_choices = CHOICE_INPUT
      @instruction = "You just found the #{@weapon.name}! Equip? (#{@possible_choices.join('/')})"
    else
      false
    end
  end
end
