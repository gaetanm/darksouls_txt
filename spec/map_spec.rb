# frozen_string_literal: true

require 'spec_helper'
require_relative '../map'
require_relative '../dungeon'

RSpec.describe Map do
  let(:room_nbr) { 10 }
  let(:dungeon) { Dungeon.new(room_nbr) }
  let(:map) { described_class.new(dungeon) }

  describe '#draw' do
    subject(:draw) { map.draw }

    before { dungeon.generate_rooms }

    context 'when the game starts' do
      it 'draws the player and all rooms as unvisited' do
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 1)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
      end
    end
  end
end
