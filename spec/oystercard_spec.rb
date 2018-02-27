require 'oystercard'
require 'station'
  describe Oystercard do
    #oystercard = Oystercard.new
    subject(:oystercard) {described_class.new}
    subject(:oystercard_empty) {described_class.new}
    let(:station_dbl) { double :station }
    let(:exit_station_dbl) { double :station }
    let(:journey) { {station_dbl: station_dbl, exit_station_dbl: exit_station_dbl }}

    before do
      oystercard.balance = 1
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
        expect { oystercard_empty.touch_in(station_dbl) }.to raise_error("Sorry, not enough credit in balance (£#{oystercard_empty.balance})")
      end

      it 'should NOT raise an error when at minimum balance' do
        oystercard.top_up(1)
        expect { oystercard.touch_in(station_dbl) }.not_to raise_error
      end

      it 'should reduce the balance by minimum fare when touch_out' do
        oystercard.top_up(1)
        expect { oystercard.touch_out(exit_station_dbl) }.to change {oystercard.balance}.by(-Oystercard::MINIMUM_FARE)
      end

    end

    describe "check and change journey status" do
      it "should start the journey when touch in" do
        oystercard.top_up(1)
        oystercard.touch_in(station_dbl)
        expect(oystercard.in_journey?).to be_truthy
      end

      it 'should end the journey when touch out' do
        oystercard.touch_in(station_dbl)
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
        entry_station = Station.new("entry_station")
        exit_station = Station.new("exit_station")
        oystercard.touch_in(entry_station)
        oystercard.touch_out(exit_station)
        expect(oystercard.history).to include [{:entry_station => :exit_station}]
      end


    end


    end

  end
