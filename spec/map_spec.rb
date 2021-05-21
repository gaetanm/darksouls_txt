# frozen_string_literal: true

require 'spec_helper'
require_relative '../map'
require_relative '../dungeon'

RSpec.describe Map do
  let(:room_nbr) { 10 }
  let(:game_mode) { :normal }
  let(:dungeon) { Dungeon.new(room_nbr) }
  let(:player_position) { dungeon.rooms[0].position }
  let(:weapon) { Weapon.new(dungeon.rooms[1].position) }
  let(:boss_position) { dungeon.rooms[2].position }
  let(:map) { described_class.new(dungeon, player_position, boss_position, weapon, game_mode) }

  describe '#draw' do
    subject(:draw) { map.draw }

    context 'when game mode is normal' do
      it 'draws the player and all rooms as unvisited' do
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 1)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
      end
    end

    context 'when game mode is debug' do
      let(:game_mode) { :debug }

      it 'draws the player and all rooms but also the weapon and the boss' do
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 3)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
        expect(draw.scan(Map::BOSS_IMG).size).to eq(1)
        expect(draw.scan(Map::WEAPON_IMG).size).to eq(1)
      end
    end

    context 'when a room is visited' do
      before { dungeon.rooms.last.visited = true }

      it 'show the room as visited' do
        expect(draw.scan(Map::VISITED_ROOM_IMG).size).to eq(1)
        expect(draw.scan(Map::UNVISITED_ROOM_IMG).size).to eq(room_nbr - 2)
        expect(draw.scan(Map::PLAYER_IMG).size).to eq(1)
      end
    end
  end
end
