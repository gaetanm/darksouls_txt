# frozen_string_literal: true

require 'spec_helper'
require_relative '../dungeon'

RSpec.describe Dungeon do
  let(:room_nbr) { 10 }
  let(:dungeon) { described_class.new(room_nbr) }
  let(:map) { Map.new(dungeon) }

  describe '#generate_rooms' do
    subject(:generate_rooms) { dungeon.generate_rooms }

    it 'generates the correct number of rooms' do
      expect(generate_rooms.size).to eq 10
    end

    it 'cannot generate are room which is not connected to another' do
      expect(generate_rooms.map(&:around_rooms_ids)).not_to include nil
    end

    it 'generates room with uniq positon' do
      rooms_positions = generate_rooms.map(&:position)
      expect(rooms_positions.uniq.size).to eq rooms_positions.size
    end
  end
end
