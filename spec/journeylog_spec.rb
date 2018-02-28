require 'journeylog'

describe JourneyLog do

  let(:journey_comp) { double :journey_comp }
  let(:journey_incomp) { double :journey_incomp }
  let(:station_dbl) { double(:station_dbl) }
  let(:station_dbl_2) { double(:station_dbl_2) }

  subject(:jlog_comp) { described_class.new(journey_comp)}
  subject(:jlog_incomp) { described_class.new(journey_incomp)}

  before do
    #allow(journey_comp).to receive(:fare) {1}
    #allow(journey_incomp).to receive(:fare) {6}
    allow(journey_comp).to receive(:calc_fare) {1}
    allow(journey_incomp).to receive(:calc_fare) {6}
  end


  it 'should start a new journey' do
    jlog_comp.start(station_dbl)
    expect(jlog_comp.this_journey[:entry]).to eq station_dbl
  end

  it 'should finish a journey' do
    jlog_comp.finish(station_dbl_2)
    expect(jlog_comp.this_journey[:exit]).to eq station_dbl_2
  end


  it 'should tell us if the journey is complete' do
    jlog_comp.start(station_dbl)
    jlog_comp.finish(station_dbl_2)
    expect(jlog_comp.complete?).to be_truthy
  end

  it 'should tell us if the journey is incomplete (no touch out)' do
    jlog_incomp.start(station_dbl)
    jlog_incomp.finish()
    expect(jlog_incomp.complete?).to be_falsey
  end

  it 'shoud log a single complete journey' do
    jlog_comp.start(station_dbl)
    jlog_comp.finish(station_dbl_2)
    expect(jlog_comp.history).to eq [{entry: station_dbl, exit: station_dbl_2, fare: 1}]
  end

  it 'should log multiple complete journeys' do
    jlog_comp.start(station_dbl)
    jlog_comp.finish(station_dbl_2)
    jlog_comp.start(station_dbl_2)
    jlog_comp.finish(station_dbl)
    expect(jlog_comp.history).to eq [{entry: station_dbl, exit: station_dbl_2, fare: 1}, {entry: station_dbl_2, exit: station_dbl, fare: 1}]
  end

  it 'shoud log a single incomplete journey' do
    jlog_incomp.start(station_dbl)
    jlog_incomp.finish()
    expect(jlog_incomp.history).to eq [{entry: station_dbl, exit: nil, fare: 6}]
  end

  it 'should log multiple incomplete journeys' do
    jlog_incomp.start(station_dbl)
    jlog_incomp.finish(station_dbl_2)
    jlog_incomp.start(station_dbl_2)
    jlog_incomp.finish()
    expect(jlog_incomp.history).to eq [{entry: station_dbl, exit: station_dbl_2, fare: 6}, {entry: station_dbl_2, exit: nil, fare: 6}]
  end
end
