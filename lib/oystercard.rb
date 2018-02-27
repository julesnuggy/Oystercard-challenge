require_relative 'station.rb'
require_relative 'journey.rb'

class Oystercard
  DEFAULT_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 5
  JOURNEYS = []
  attr_accessor :balance, :minimum_balance, :entry_station, :exit_station, :journeys

  def initialize(limit = DEFAULT_LIMIT, minimum = MINIMUM_BALANCE, journeys = JOURNEYS)
    @balance = 0
    @limit = limit
    @minimum_balance = minimum
    @journeys = journeys
  end

  def top_up(amount)
    raise "Sorry, you've reached the limit of £#{@limit}" if @balance + amount > @limit
    @balance += amount
  end

  def touch_in(station_object)
    raise "Sorry, not enough credit in balance (£#{@balance})" if @balance < @minimum_balance
    @entry_station = station_object
  end

  def touch_out(station_object)
    deduct(MINIMUM_FARE)
    @entry_station = nil
    @exit_station = station_object
  end

  def in_journey?
    !!@entry_station
  end

  def history
    @journeys << {:entry_station => :exit_station}
  end

  private

  def deduct(fare_amount)
    journey = Journey.new
    journey.fare = fare_amount
    @balance -= journey.fare
  end
end
