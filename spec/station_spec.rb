require 'station'

describe Station do
  subject(:station) { described_class.new('Camden', '2') }

  it 'should return the station name' do
    expect(station.name).to eq 'Camden'
  end

  it 'should return the station zone' do
    expect(station.zone).to eq '2'
  end
end
