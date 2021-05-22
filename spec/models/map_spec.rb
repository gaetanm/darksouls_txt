# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../models/map'
require_relative '../../models/dungeon'

RSpec.describe Map do
  let(:room_nbr) { 10 }
  let(:dungeon) { Dungeon.new(room_nbr) }
  let(:player_position) { dungeon.rooms[0].position }
  let(:weapon) { Weapon.new(dungeon.rooms[1].position) }
  let(:boss) { Boss.new(dungeon.rooms[2].position) }
  let(:map) { described_class.new(dungeon, player_position, boss, weapon) }

  describe '#draw' do
    subject(:draw) { map.draw }

    it 'draws the player and all rooms as unvisited' do
      expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 1)
      expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
      expect(draw.scan(Map::WEAPON_IMG).size).to eq(0)
      expect(draw.scan(Map::BOSS_IMG).size).to eq(0)
    end

    context 'when a room is visited' do
      before { dungeon.rooms.last.visited = true }

      it 'show the room as visited' do
        expect(draw.scan(Map::VISITED_ROOM_IMG).size).to eq(1)
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 2)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
        expect(draw.scan(Map::WEAPON_IMG).size).to eq(0)
        expect(draw.scan(Map::BOSS_IMG).size).to eq(0)
      end
    end

    context 'when weapon is discovered' do

      before { weapon.discovered = true}

      it 'draws the player and the weapon' do
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 2)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
        expect(draw.scan(Map::WEAPON_IMG).size).to eq(1)
        expect(draw.scan(Map::BOSS_IMG).size).to eq(0)
      end
    end

    context 'when boss is discovered' do

      before { weapon.discovered = true }

      it 'draws the player and the boss' do
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 2)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
        expect(draw.scan(Map::WEAPON_IMG).size).to eq(1)
        expect(draw.scan(Map::BOSS_IMG).size).to eq(0)
      end
    end
  end
end
