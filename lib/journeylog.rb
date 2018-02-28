require_relative 'station.rb'
require_relative 'journey.rb'

class JourneyLog
  attr_accessor :entry_station, :exit_station
  attr_reader :history, :fare, :this_journey

  def initialize(journey_calc = JourneyCalculator.new)
    @journey_calc = journey_calc
    @history = []
    @this_journey = {}
    @entry_station = @exit_station = nil
  end

  def start(station = nil)
    @entry_station = station
    @this_journey[:entry] = station
  end

  def finish(station = nil)
    @exit_station = station
    @this_journey[:exit] = station
    #get_fare(@entry_station, @exit_station)
    get_fare
    set_history
    @entry_station = @exit_station = nil
    station
  end

  def get_fare
    @fare = @journey_calc.calc_fare(@entry_station, @exit_station)
    @this_journey[:fare] = @fare
  end

  def complete?
    #current_journey
    return (!@history[-1][:entry].nil? && !@history[-1][:exit].nil?) if !@history.empty?
  end

  private

  def set_history
    #get_fare
    @history << @this_journey.dup
  end

end
