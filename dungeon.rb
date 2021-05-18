# frozen_string_literal: true

require_relative 'room'

Position = Struct.new(:x, :y)

class Dungeon
  attr_reader :rooms

  def initialize(rooms_nbr)
    @rooms_nbr = rooms_nbr
    @rooms = []
  end

  def generate_rooms
    current_room_position = Position.new(0, 0)
    @rooms_nbr.times do |room_id|
      @rooms << Room.new(room_id, current_room_position)
      current_room_position = generate_room_position(current_room_position) || find_position_from_existing_rooms
    end
    # At the end because during room generation, a room can appear next to a room that was generated before
    connect_rooms
  end

  def find_position_from_existing_rooms
    @rooms.map(&:position).each do |position|
      found_position = generate_room_position(position)
      return found_position if found_position
    end
  end

  def all_x_points
    @rooms.map(&:position).map(&:x)
  end

  def all_y_points
    @rooms.map(&:position).map(&:y)
  end

  private

  def connect_rooms
    @rooms.each do |room|
      room.around_rooms_ids = rooms_around(room.position).map(&:id)
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
