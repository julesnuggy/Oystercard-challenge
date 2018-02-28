require 'journey'
require 'oystercard'

describe Journey do
  #oystercard = Oystercard.new ### Need to make this a double at some point
  let(:oystercard) { double :oystercard }
  subject(:journey) {described_class.new}
  let(:station_dbl) { double :station_dbl }
  let(:exit_station_dbl) { double :exit_station_dbl }

  before do
    allow(oystercard).to receive(:touch_in) {:station_dbl}
    allow(oystercard).to receive(:touch_out) {:exit_station_dbl}

  end

  describe "check and change journey status" do
    it "should start the journey when touch in" do
      expect(journey.start(station_dbl)).to eq station_dbl
    end

    it 'should end the journey when touch out' do
      expect(journey.finish(exit_station_dbl)).to eq exit_station_dbl
    end

    it 'should be false when not in journey' do
      expect(journey.in_journey?).to be_falsey
    end

    it 'should be true when in journey' do
      journey.start(station_dbl)
      expect(journey.in_journey?).to be_truthy
    end
  end

  describe 'keep track of journey history' do
    it 'logs the entry station' do
      journey.start(station_dbl)
      expect(journey.entry_station).to eq station_dbl
    end
  end

  describe 'journey history' do

    it 'should return an empty list of journeys by default' do
      expect(journey.history).to be_empty
    end

    it 'should store the entry station and the exit station in a hash' do
      journey.start(:station_dbl)
      journey.finish(:exit_station_dbl)
      expect(journey.history).to eq [{:entry_station => :station_dbl, :exit_station => :exit_station_dbl}]
    end

    it 'should record a multi-journey history' do
      journey.start(:station_dbl)
      journey.finish(:exit_station_dbl)
      journey.start(:exit_station_dbl)
      journey.finish(:station_dbl)
      expect(journey.history).to eq [{:entry_station => :station_dbl, :exit_station => :exit_station_dbl}, {:entry_station => :exit_station_dbl, :exit_station => :station_dbl}]
     end

    it 'should return whether the journey is complete' do
      journey.start(:station_dbl)
      journey.finish(:exit_station_dbl)
      expect(journey.complete?).to be_truthy
    end

    it 'should return whether the journey is not complete' do
      journey.start(:station_dbl)
      journey.finish(nil)
      expect(journey.complete?).to be_falsey
    end
end

describe 'fare calculation' do

it 'should return the minimum fare for a completed journey' do
  allow(journey).to receive(:complete?) { true }
  expect(journey.fare).to eq Journey::MINIMUM_FARE
end

it 'should return the penalty fare for an incomplete journey' do
  allow(journey).to receive(:complete?) { false }
  expect(journey.fare).to eq Journey::PENALTY_FARE
end

end
end
