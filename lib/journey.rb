class Journey
  MINIMUM_FARE = 1
  PENALTY_FARE = 6


  attr_accessor :entry_station, :exit_station
  attr_reader :history, :fare

  def initialize(min_fare = MINIMUM_FARE, penalty_fare = PENALTY_FARE)
    @entry_station = nil
    @exit_station = nil
    @history = []
    @min_fare =  min_fare
    @penalty_fare = penalty_fare
  end

  def in_journey?
    @entry_station !=nil
  end

  def start(station)
    @entry_station = station
  end

  def finish(station)
    @exit_station = station
    @history << {:entry_station => @entry_station, :exit_station => @exit_station}
    @exit_station
  end

  def complete?
    if @history.last[:entry_station].nil? || @history.last[:exit_station].nil?
      false
    else
      true
    end
  end

  def fare
    if complete?
      @min_fare
    else
      @penalty_fare
  end
end

end
