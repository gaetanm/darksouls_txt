# frozen_string_literal: true

require 'spec_helper'
require_relative '../dungeon'

RSpec.describe Dungeon do
  let(:room_nbr) { 10 }
  let(:dungeon) { described_class.new(room_nbr) }

  describe '#initialize' do
    it 'generates the correct number of rooms' do
      expect(dungeon.rooms.size).to eq 10
    end

    it 'cannot generate are room which is not connected to another' do
      expect(dungeon.rooms.map(&:around_rooms_positions)).not_to include nil
    end

    it 'generates room with uniq position' do
      rooms_positions = dungeon.rooms.map(&:position)
      expect(rooms_positions.uniq.size).to eq rooms_positions.size
    end
  end

  describe '#random_room_position' do
    subject(:random_room_position) { dungeon.random_room_position(positions_to_avoid) }

    let(:positions_to_avoid) { dungeon.rooms.map(&:position).sample(2) }

    it 'gives a random room position that is not a position to avoid' do
      expect(positions_to_avoid).not_to include(random_room_position)
    end
  end

  describe '#room_from_position' do
    subject(:room_from_position) { dungeon.room_from_position(room_position) }

    let(:room) { dungeon.rooms[0] }
    let(:room_position) { dungeon.rooms[0].position }

    it 'returns the room having the given position' do
      expect(room_from_position).to eq(room)
    end
  end
end
