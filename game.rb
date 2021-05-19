# frozen_string_literal: true

require_relative 'dungeon'
require_relative 'map'
require_relative 'boss'
require_relative 'player'
require_relative 'weapon'

class Game
  ROOMS_NBR = 10

  def initialize
    @dungeon = Dungeon.new(ROOMS_NBR)
    @player = Player.new(@dungeon.first_room_position, 'Undead')
    @weapon = Weapon.new(@dungeon.random_room_position([@player.position]))
    @boss = Boss.new(@dungeon.random_room_position([@player.position, @weapon.position]))
    @map = Map.new(@dungeon, @player.position, @boss.position, @weapon.position, :normal)
  end

  def start
    puts @map.draw
  end
end
