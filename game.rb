# frozen_string_literal: true

require 'readline'
require_relative 'dungeon'
require_relative 'map'
require_relative 'boss'
require_relative 'player'
require_relative 'weapon'
require_relative 'direction_service'

class Game
  MOVING_INPUT = %w[right left top bottom].freeze
  CHOICE_INPUT = %w[yes no].freeze

  def self.start(room_nbr)
    return unless bootable?(room_nbr)

    new(room_nbr).run
  end

  def self.bootable?(room_nbr)
    return true if room_nbr.between?(5, 100)

    puts 'Room number has to be between 5 and 100.'
    false
  end

  def initialize(room_nbr)
    boot(room_nbr)
    @possible_choices = @direction_service.possible_directions(@player.position)
    @instruction = "Where to go? (#{@possible_choices.join('/')})"
    @screen = @map.draw
    @action = :moving
  end

  def run
    help = "\\o/: YOU\n[ x ]: Unvisited room\n[   ]: Visited room\nType 'exit' to quit"
    refresh_screen
    while input = Readline.readline("#{help}\n\n#{@screen}\n\n#{@instruction} ", true)
      break if input == 'exit'

      handle_input(input) if @possible_choices.include?(input)
      refresh_screen
    end
  end

  private

  def boot(room_nbr)
    @dungeon = Dungeon.new(room_nbr)
    @direction_service = DirectionService.new(@dungeon)
    @player = Player.new(@dungeon.first_room_position.clone, 'Undead')
    @weapon = Weapon.new(@dungeon.random_room_position([@player.position]).clone)
    @boss = Boss.new(@dungeon.random_room_position([@player.position, @weapon.position].clone))
    @map = Map.new(@dungeon, @player.position, @boss.position, @weapon, :debug)
  end

  def handle_input(input)
    handle_moving(input) if MOVING_INPUT.include?(input) && @action == :moving
    handle_equipping(input) if CHOICE_INPUT.include?(input) && @action == :equipping
  end

  def refresh_screen
    system('clear') || system('cls')
    @screen = @map.draw
  end

  def handle_equipping(input)
    @possible_choices = @direction_service.possible_directions(@player.position)
    if input == 'yes'
      @instruction = "You can now kill the boss!\nWhere to go? (#{@possible_choices.join('/')})"
      @weapon.equipped = true
    else
      @instruction = "#{@boss.name} will kick your ass for sure!\nWhere to go? (#{@possible_choices.join('/')})"
    end
    @action = :moving
  end

  def handle_moving(input)
    @player.walk(input)
    @dungeon.mark_room_as_visited(@player.position)
    return if collision?

    @possible_choices = @direction_service.possible_directions(@player.position)
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
