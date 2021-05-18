# frozen_string_literal: true
#
require_relative 'dungeon'
require_relative 'map'

class GameMaster
  ROOMS = 10
  MONSTERS = 4
  BOSSES = 1
  ITEMS = 5

  def self.game_bootable?
    [MONSTERS, BOSSES, ITEMS].sum <= ROOMS
  end

  def initialize(dungeon = Dungeon.new(10), map = Map.new(@dungeon))
    @dungeon = dungeon
    @map = map
  end

  def show_map
    puts @map.draw
  end
end
