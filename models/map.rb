# frozen_string_literal: true

require_relative '../engine/game'

class Map
  UNVISITED_ROOM_IMG = '[ x ]'
  VISITED_ROOM_IMG = '[   ]'
  EMPTY_ROOM_IMG = '|||||'
  PLAYER_IMG = '[\o/]'
  WEAPON_IMG = '[ W ]'
  BOSS_IMG = '[ B ]'

  def initialize(dungeon, player_position, boss, weapon)
    @dungeon = dungeon
    @player_position = player_position
    @boss = boss
    @weapon = weapon
  end

  def draw
    map = ''
    all_x = @dungeon.all_x_points
    all_y = @dungeon.all_y_points
    current_y = all_y.max
    (all_y.min..all_y.max).to_a.reverse.each do |y|
      (all_x.min..all_x.max).each do |x|
        map += draw_line(Position.new(x, y), current_y)
        current_y = y
      end
    end
    map
  end

  private

  def draw_line(position, current_y)
    line = ''
    line += "\n" if position.y != current_y
    line += draw_room_or_player(position)
    line
  end

  def draw_room_or_player(position)
    if @player_position == position
      PLAYER_IMG
    elsif @weapon.position == position && @weapon.discovered
      @weapon.equipped == true ? draw_room(position) : WEAPON_IMG
    elsif @boss.position == position && @boss.discovered
      BOSS_IMG
    else
      draw_room(position)
    end
  end

  def draw_room(position)
    if (room = @dungeon.room_from_position(position))
      room.visited ? VISITED_ROOM_IMG : UNVISITED_ROOM_IMG
    else
      EMPTY_ROOM_IMG
    end
  end
end
