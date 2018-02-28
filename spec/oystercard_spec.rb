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
    let(:jlog_double) { double :jlog_double }

    before do
      oystercard.balance = 10
      oystercard_min.balance = 1
      #allow(jlog_dbl).to receive(:fare) { 1 }
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
        oystercard.touch_in(:station_dbl)
        #expect(oystercard.touch_out(exit_station_dbl)).to
        expect { oystercard.touch_out(exit_station_dbl) }.to change {oystercard.balance}.by(-1)
      end

    end


  end
