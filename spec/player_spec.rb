# frozen_string_literal: true

require 'spec_helper'
require_relative '../player'

RSpec.describe Player do
  let(:position) { Position.new(0, 0) }
  let(:player) { described_class.new(position, 'Undead') }

  describe '#walk' do
    let(:direction) { 'right' }
    subject(:walk) { player.walk(direction) }

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
