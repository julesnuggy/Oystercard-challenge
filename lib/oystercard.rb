require_relative 'station.rb'
require_relative 'journey.rb'

class Oystercard
  DEFAULT_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 5
  attr_accessor :balance, :minimum_balance, :entry_station, :exit_station

  def initialize(limit = DEFAULT_LIMIT, minimum = MINIMUM_BALANCE)
    @balance = 0
    @limit = limit
    @minimum_balance = minimum
  end

  def top_up(amount)
    raise "Sorry, you've reached the limit of £#{@limit}" if @balance + amount > @limit
    @balance += amount
  end

  def touch_in(station_object)
    raise "Sorry, not enough credit in balance (£#{@balance})" if @balance < @minimum_balance
    @entry_station = station_object
  end

  def touch_out(exit_station)
    deduct(MINIMUM_FARE)
    @exit_station = exit_station
    @entry_station = nil
  end

  def in_journey?
    # Return true if @entry_station is NOT nil (i.e. in journey)
    !@entry_station.nil?
  end

  private

  def deduct(fare_amount)
    journey = Journey.new
    journey.fare = fare_amount
    @balance -= journey.fare
  end
end
