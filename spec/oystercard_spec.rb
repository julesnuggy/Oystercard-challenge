require 'oystercard'
require 'station'
require 'journey'

  describe Oystercard do
    #oystercard = Oystercard.new
    subject(:oystercard) {described_class.new}
    subject(:oystercard_empty) {described_class.new}
    subject(:oystercard_min) {described_class.new}
    let(:station_dbl) { double :station_dbl }
    let(:exit_station_dbl) { double :exit_station_dbl }
    let(:journey) { {station_dbl: station_dbl, exit_station_dbl: exit_station_dbl }}

    before do
      oystercard.balance = 10
      oystercard_min.balance = 1
    end

    describe "check balance and enforce limits" do

      it 'should have a balance of 0 when initialized' do
        expect(oystercard_empty.balance).to eq 0
      end

      it 'should respond to #top_up by adding money to the balance' do
        expect { oystercard.top_up(10) }.to change {oystercard.balance}.by(10)
      end

      it 'should raise an error when exceed the limit' do
        expect { oystercard.top_up(100) }.to raise_error("Sorry, you've reached the limit of £#{Oystercard::DEFAULT_LIMIT}")
      end

      it 'should raise an error when below minimum balance' do
        expect { oystercard_empty.touch_in(station_dbl) }.to raise_error("Sorry, not enough credit in balance £#{oystercard_empty.balance}")
      end

      it 'should NOT raise an error when at minimum balance' do
        expect { oystercard_min.touch_in(station_dbl) }.not_to raise_error
      end

      it 'should reduce the balance by minimum fare when touch_out' do
        expect { oystercard.touch_out(exit_station_dbl) }.to change {oystercard.balance}.by(-Oystercard::MINIMUM_FARE)
      end

    end

    describe "check and change journey status" do
      it "should start the journey when touch in" do
        oystercard.touch_in(station_dbl)
        expect(oystercard.in_journey?).to be_truthy
      end

      it 'should end the journey when touch out' do
        oystercard.touch_out(exit_station_dbl)
        expect(oystercard.in_journey?).to be_falsey
      end

      it 'should be false when not in journey' do
        expect(oystercard.in_journey?).to be_falsey
      end

      it 'should be true when in journey' do
        oystercard.touch_in(station_dbl)
        expect(oystercard.in_journey?).to be_truthy
      end

    describe 'keep track of journey history' do
      it 'logs the entry station' do
        oystercard.touch_in(station_dbl)
        expect(oystercard.entry_station).to eq station_dbl
      end
    end

    describe 'journey history' do

      it 'should return an empty list of journeys by default' do
        expect(oystercard.history).to be_empty
      end

      it 'should store the entry station and the exit station in a hash' do
        oystercard.touch_in(:station_dbl)
        oystercard.touch_out(:exit_station_dbl)
        expect(oystercard.history).to eq [{:entry_station => :station_dbl, :exit_station => :exit_station_dbl}]
      end

      it 'should record a multi-journey history' do
        oystercard.touch_in(:station_dbl)
        oystercard.touch_out(:exit_station_dbl)
        oystercard.touch_in(:exit_station_dbl)
        oystercard.touch_out(:station_dbl)
        expect(oystercard.history).to eq [{:entry_station => :station_dbl, :exit_station => :exit_station_dbl}, {:entry_station => :exit_station_dbl, :exit_station => :station_dbl}]
      end

    end


    end

  end
