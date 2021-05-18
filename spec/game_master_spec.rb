# frozen_string_literal: true

require 'spec_helper'
require_relative '../game_master'

RSpec.describe GameMaster do
  let(:game_master) { described_class.new(dungeon, map) }
  let(:room_nbr) { 10 }
  let(:dungeon) { Dungeon.new(room_nbr) }
  let(:map) { Map.new(dungeon) }

  describe '#show_map' do
    subject(:show_map) { game_master.show_map }

    before do
      allow(map).to receive(:draw)
      show_map
    end

    it { expect(map).to have_received(:draw) }
  end
end
