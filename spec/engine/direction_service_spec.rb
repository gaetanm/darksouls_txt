# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../models/position'
require_relative '../../engine/direction_service'
require_relative '../../models/dungeon'

RSpec.describe DirectionService do
  let(:room_nbr) { 2 }
  let(:dungeon) { Dungeon.new(room_nbr) }
  let(:direction_service) { described_class.new(dungeon) }

  describe '.calculate_direction' do
    subject(:calculate_direction) { described_class.calculate_directions(current_position, position) }

    let(:current_position) { Position.new(0, 0) }
    let(:position) { Position.new(1, 0) }

    context 'when position is at the right of the current position' do
      it { is_expected.to eq 'right' }
    end

    context 'when position is at the left of the current position' do
      let(:position) { Position.new(-1, 0) }

      it { is_expected.to eq 'left' }
    end

    context 'when position is at the top of the current position' do
      let(:position) { Position.new(0, 1) }

      it { is_expected.to eq 'top' }
    end

    context 'when position is at the bottom of the current position' do
      let(:position) { Position.new(0, -1) }

      it { is_expected.to eq 'bottom' }
    end
  end

  describe '#possible_directions' do
    subject(:possible_directions) { described_class.new(dungeon).possible_directions(current_position) }

    let(:current_position) { Position.new(0, 0) }

    context 'when there are 2 rooms on the map' do
      it 'returns only one possible direction' do
        expect(possible_directions.size).to eq 1
      end
    end
  end
end
