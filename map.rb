# frozen_string_literal: true

require_relative 'game'

class Map
  UNVISITED_ROOM_IMG = '[ x ]'
  VISITED_ROOM_IMG = '[   ]'
  EMPTY_ROOM_IMG = '     '
  PLAYER_IMG = '[\o/]'
  WEAPON_IMG = '[ W ]'
  BOSS_IMG = '[ B ]'

  def initialize(dungeon, player_position, boss_position, weapon_position, game_mode)
    @game_mode = game_mode
    @dungeon = dungeon
    @player_position = player_position
    @boss_position = boss_position
    @weapon_position = weapon_position
  end

  def draw
    map = ''
    all_x = @dungeon.all_x_points
    all_y = @dungeon.all_y_points
    current_x = all_x.min
    (all_x.min..all_x.max).each do |x|
      (all_y.min..all_y.max).each do |y|
        map += draw_line(Position.new(x, y), current_x)
        current_x = x
      end
    end
    map
  end

  private

  def draw_line(position, current_x)
    line = ''
    line += "\n" if position.x != current_x
    line += draw_room_or_player(position)
    line
  end

  def draw_room_or_player(position)
    return (position == @player_position ? PLAYER_IMG : draw_room(position)) if @game_mode == :normal

    case position
    when @player_position
      PLAYER_IMG
    when @weapon_position
      WEAPON_IMG
    when @boss_position
      BOSS_IMG
    else
      draw_room(position)
    end
  end

  def draw_room(position)
    @dungeon.rooms.map(&:position).include?(position) ? UNVISITED_ROOM_IMG : EMPTY_ROOM_IMG
  end
end
