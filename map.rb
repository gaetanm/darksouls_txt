# frozen_string_literal: true

class Map
  UNVISITED_ROOM_IMG = '[ x ]'
  VISITED_ROOM_IMG = '[   ]'
  EMPTY_ROOM_IMG = '     '
  PLAYER_IMG = '[\o/]'

  def initialize(dungeon)
    @dungeon = dungeon
  end

  def draw
    map = ''
    all_x = @dungeon.all_x_points
    all_y = @dungeon.all_y_points
    current_x = all_x.min
    (all_x.min..all_x.max).each do |x|
      (all_y.min..all_y.max).each do |y|
        map += draw_line(x, y, current_x)
        current_x = x
      end
    end
    map
  end

  private

  def draw_line(x, y, current_x)
    line = ''
    line += "\n" if x != current_x
    line += draw_room_or_player(x, y)
    line
  end

  def draw_room_or_player(x, y)
    x.zero? && y.zero? ? PLAYER_IMG : draw_room(x, y)
  end

  def draw_room(x, y)
    @dungeon.rooms.map(&:position).include?(Position.new(x, y)) ? UNVISITED_ROOM_IMG : EMPTY_ROOM_IMG
  end
end
