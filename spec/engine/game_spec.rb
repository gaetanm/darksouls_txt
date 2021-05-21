# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../engine/game'

RSpec.describe Game do
  let(:room_nbr) { 10 }

  describe '.bootable?' do
    subject(:bootable) { described_class.bootable?(room_nbr) }

    context 'when the room number is between 5 and 100' do
      it { is_expected.to be true }
    end

    context 'when there is less than 5 rooms' do
      let(:room_nbr) { 2 }

      it { is_expected.to be false }
    end

    context 'when there is more than 100 rooms' do
      let(:room_nbr) { 500 }

      it { is_expected.to be false }
    end
  end
end
