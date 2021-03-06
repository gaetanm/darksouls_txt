# frozen_string_literal: true

require_relative 'position'
require_relative 'room'

class Dungeon
  attr_reader :rooms

  def initialize(rooms_nbr, rooms = nil)
    @rooms_nbr = rooms_nbr
    @rooms = rooms || []
    generate_rooms
  end

  def mark_room_as_visited(position)
    room_from_position(position).visited = true
  end

  def room_from_position(position)
    @rooms.find { |room| room.position == position }
  end

  def all_x_points
    @rooms.map(&:position).map(&:x)
  end

  def all_y_points
    @rooms.map(&:position).map(&:y)
  end

  def last_room_position
    @rooms.last.position
  end

  def first_room_position
    @rooms.first.position
  end

  def random_room_position(positions_to_avoid)
    position = @rooms.map(&:position).sample
    return position unless positions_to_avoid.include? position

    random_room_position(positions_to_avoid)
  end

  private

  def generate_rooms
    if @rooms.empty?
      current_room_position = Position.new(0, 0)
      @rooms_nbr.times do |room_id|
        @rooms << Room.new(room_id, current_room_position)
        current_room_position = generate_room_position(current_room_position) || find_position_from_existing_rooms
      end
    end
    connect_rooms
  end

  def find_position_from_existing_rooms
    @rooms.map(&:position).each do |position|
      found_position = generate_room_position(position)
      return found_position if found_position
    end
  end

  def connect_rooms
    @rooms.each do |room|
      room.around_rooms_positions = rooms_around(room.position).map(&:position)
    end
  end

  def generate_room_position(position)
    (around_position(position) - used_positions).sample
  end

  def used_positions
    return [] if @rooms.empty?

    @rooms.map(&:position)
  end

  def rooms_around(position)
    return [] if @rooms.empty?

    @rooms.find_all { |room| around_position(position).include?(room.position) }
  end

  def around_position(position)
    [Position.new(position.x, position.y - 1), Position.new(position.x + 1, position.y),
     Position.new(position.x - 1, position.y), Position.new(position.x, position.y + 1)]
  end
end
