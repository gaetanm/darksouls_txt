# frozen_string_literal: true

require_relative '../spec_helper'
require_relative '../../engine/action_handler'
require_relative '../../engine/direction_service'
require_relative '../../models/dungeon'
require_relative '../../models/player'
require_relative '../../models/weapon'
require_relative '../../models/boss'

RSpec.describe ActionHandler do
  let(:dungeon) { Dungeon.new(3, rooms) }
  let(:positions) { [Position.new(0, 0), Position.new(1, 0), Position.new(2, 0), Position.new(3, 0)] }
  let(:rooms) { positions.map.with_index { |p, i| Room.new(i, p) } }
  let(:direction_service) { DirectionService.new(dungeon) }
  let(:player_position) { Position.new(0, 0) }
  let(:weapon_position) { Position.new(2, 0) }
  let(:boss_position) { Position.new(3, 0) }
  let(:player) { Player.new(player_position, 'Undead') }
  let(:weapon) { Weapon.new(weapon_position) }
  let(:boss) { Boss.new(boss_position) }
  let(:action_handle) { described_class.new(direction_service, player, weapon, boss, dungeon) }

  describe '.initialize' do
    it { expect(action_handle.instruction).to include('Where to go?') }
  end

  describe '#handle_input' do
    subject(:handle_input) { action_handle.handle_input(input) }

    before { allow(action_handle).to receive(:action).and_return(action) }

    describe 'moving' do
      let(:action) { :moving }
      let(:input) { nil }

      it { expect(action_handle.instruction).to include('Where to go?') }
      it { expect(action_handle.possible_choices).to eq(['right']) }
      it { expect(handle_input).not_to be true }

      context 'when input is not related to the possible directions' do
        let(:input) { 'top' }

        it { expect(action_handle.instruction).to include('Where to go?') }
        it { expect { subject }.to_not(change { player.position }) }
      end

      context 'when the input is related to a possible directions' do
        let(:input) { 'right' }

        it { expect { subject }.to(change { player.position }) }
      end

      describe 'collisions' do
        before { handle_input }

        context 'when the player meet the boss' do
          let(:player_position) { Position.new(2, 0) }
          let(:input) { 'right' }

          it { expect(action_handle.instruction).to include('Holy shit! Artorias is here!') }
          it { expect(action_handle.possible_choices).to eq(%w[fight run]) }
        end

        context 'when the player find the weapon' do
          let(:player_position) { Position.new(1, 0) }
          let(:input) { 'right' }

          it { expect(action_handle.instruction).to include('You just found the Moonlight Greatsword! Equip?') }
          it { expect(action_handle.possible_choices).to eq(%w[yes no]) }
        end
      end
    end

    describe 'equipping' do
      let(:action) { :equipping }

      context 'when input is yes' do
        let(:input) { 'yes' }

        before do
          action_handle.handle_input('right')
          action_handle.handle_input('right')
          handle_input
        end

        it { expect(action_handle.instruction).to include('You can now kill the boss') }
        it { expect(action_handle.possible_choices).to eq(%w[left right]) }
        it { expect(weapon.equipped).to be true }
        it { expect(handle_input).not_to be true }
      end

      context 'when input is no' do
        let(:input) { 'no' }

        before do
          action_handle.handle_input('right')
          action_handle.handle_input('right')
          handle_input
        end

        it { expect(action_handle.instruction).to include('Artorias will kick your ass for sure!') }
        it { expect(action_handle.possible_choices).to eq(%w[left right]) }
        it { expect(weapon.equipped).to be false }
        it { expect(handle_input).not_to be true }
      end
    end

    describe 'aggro' do
      let(:action) { :equipping }

      before do
        action_handle.handle_input('right')
        action_handle.handle_input('right')
        action_handle.handle_input('yes')
        action_handle.handle_input('right')
      end

      context 'when input is fight' do
        context 'when the weapon is equipped' do
          let(:input) { 'fight' }

          before { handle_input }

          it { expect(action_handle.instruction).to include('Yay you won!') }
        end

        context 'when the weapon is not equipped' do
          let(:input) { 'fight' }

          before { allow(weapon).to receive(:equipped).and_return(false) }

          context 'when the player loses the fight' do

            before do
              allow(player).to receive(:win_fight_success).and_return(1)
              handle_input
            end

            it { expect(action_handle.instruction).to include('Artorias KILLED YOU! YOU DIED!') }
          end

          context 'when the player wins the fight' do

            before do
              allow(player).to receive(:win_fight_success).and_return(0)
              handle_input
            end

            it { expect(action_handle.instruction).to include('Yay you won!') }
          end
        end
      end

      context 'when input is run' do
        let(:input) { 'run' }

        context 'when the player successfully runs' do
          before do
            allow(player).to receive(:run_success).and_return(0)
            handle_input
          end

          it { expect(action_handle.instruction).to include('You lucky bastard') }
          it { expect(action_handle.possible_choices).to eq(['left']) }
          it { expect(handle_input).not_to be true }
        end

        context 'when the player fails to run' do
          before do
            allow(player).to receive(:run_success).and_return(2)
            handle_input
          end

          it { expect(action_handle.instruction).to include('That roll did not work... Artorias KILLED YOU! YOU DIED!') }
        end
      end
    end
  end
end
