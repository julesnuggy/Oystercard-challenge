class JourneyCalculator
  MINIMUM_FARE = 1
  PENALTY_FARE = 6

  attr_reader :fare

  def initialize(min_fare = MINIMUM_FARE, penalty_fare = PENALTY_FARE)
    @min_fare =  min_fare
    @penalty_fare = penalty_fare
  end

  def calc_fare(entry_station, exit_station)
    if entry_station.nil? || exit_station.nil?
      @fare = @penalty_fare
    else
      @fare = @min_fare
    end
  end

end
