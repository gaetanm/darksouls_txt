class DirectionService
  def initialize(dungeon)
    @dungeon = dungeon
  end

  def self.calculate_directions(current_position, position)
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

  def possible_directions(player_position)
    possible_directions = []
    current_room = @dungeon.room_from_position(player_position)
    current_room.around_rooms_positions.each do |position|
      possible_directions << self.class.calculate_directions(current_room.position, position)
    end
    possible_directions
  end
end
