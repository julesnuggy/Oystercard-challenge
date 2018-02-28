require 'journey'
require 'oystercard'

describe JourneyCalculator do
  #oystercard = Oystercard.new ### Need to make this a double at some point
  let(:oystercard) { double :oystercard }
  subject(:journey) {described_class.new}
  let(:station_dbl) { double :station_dbl }
  let(:exit_station_dbl) { double :exit_station_dbl }

  before do
    allow(oystercard).to receive(:touch_in) {:station_dbl}
    allow(oystercard).to receive(:touch_out) {:exit_station_dbl}

  end



describe 'fare calculation' do

it 'should return the minimum fare for a completed journey' do
  expect(journey.calc_fare(station_dbl, exit_station_dbl)).to eq JourneyCalculator::MINIMUM_FARE
end

it 'should return the penalty fare for an incomplete journey' do
  expect(journey.calc_fare(station_dbl, nil)).to eq JourneyCalculator::PENALTY_FARE
end

end
end
