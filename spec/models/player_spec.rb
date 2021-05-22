# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../models/player'

RSpec.describe Player do
  let(:position) { Position.new(0, 0) }
  let(:player) { described_class.new(position, 'Undead') }

  describe '#fight' do
    subject(:fight) { player.fight(weapon_equipped) }

    context 'when weapon is equipped' do
      let(:weapon_equipped) { true }

      it { is_expected.to be true }
    end

    context 'when weapon is not equipped' do
      let(:weapon_equipped) { false }

      context 'when no chance' do
        before { allow(player).to receive(:win_fight_success).and_return(1) }

        it { is_expected.to be false }
      end

      context 'when lucky' do
        before { allow(player).to receive(:win_fight_success).and_return(0) }

        it { is_expected.to be true }
      end
    end
  end

  describe '#run' do
    subject(:run) { player.run }

    context 'when no chance' do
      before { allow(player).to receive(:run_success).and_return(2) }

      it { is_expected.to be false }
    end

    context 'when lucky' do
      before { allow(player).to receive(:run_success).and_return(0) }

      it { is_expected.to be true }
    end
  end

  describe '#walk' do
    subject(:walk) { player.walk(direction) }

    let(:direction) { 'right' }

    context 'when direction is right' do
      it { expect { walk }.to change { player.position.x }.from(0).to(1) }
    end

    context 'when direction is left' do
      let(:direction) { 'left' }

      it { expect { walk }.to change { player.position.x }.from(0).to(-1) }
    end

    context 'when direction is top' do
      let(:direction) { 'top' }

      it { expect { walk }.to change { player.position.y }.from(0).to(1) }
    end

    context 'when direction is bottom' do
      let(:direction) { 'bottom' }

      it { expect { walk }.to change { player.position.y }.from(0).to(-1) }
    end
  end
end
