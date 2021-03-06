# frozen_string_literal: true

require 'readline'
require_relative '../models/dungeon'
require_relative '../models/map'
require_relative '../models/boss'
require_relative '../models/player'
require_relative '../models/weapon'
require_relative '../engine/direction_service'
require_relative '../engine/action_handler'

class Game
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
    @room_nbr = room_nbr
    boot
  end

  def run
    help = "\\o/: YOU\n[ x ]: Unvisited room\n[   ]: Visited room\nType 'exit' to quit"
    refresh_screen
    while input = Readline.readline("#{help}\n\n#{@screen}\n\n#{@action_handler.instruction} ", true)
      case @action_handler.handle_input(input)
      when :restart
        boot
      when :quit
        break
      else
        break if input == 'exit'
      end
      refresh_screen
    end
  end

  private

  def boot
    @dungeon = Dungeon.new(@room_nbr)
    @direction_service = DirectionService.new(@dungeon)
    @player = Player.new(@dungeon.first_room_position.clone, 'Undead')
    @weapon = Weapon.new(@dungeon.random_room_position([@player.position]).clone)
    @boss = Boss.new(@dungeon.random_room_position([@player.position, @weapon.position].clone))
    @map = Map.new(@dungeon, @player.position, @boss, @weapon)
    @action_handler = ActionHandler.new(@direction_service, @player, @weapon, @boss, @dungeon)
    @screen = @map.draw
  end

  def refresh_screen
    system('clear') || system('cls')
    @screen = @map.draw
  end
end
