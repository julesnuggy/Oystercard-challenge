require_relative 'station.rb'
require_relative 'journey.rb'

class Oystercard
  DEFAULT_LIMIT = 90
  MINIMUM_BALANCE = 1
  MINIMUM_FARE = 5

  attr_accessor :balance, :minimum_balance, :entry_station, :journeys

  def initialize(limit = DEFAULT_LIMIT)
    @balance = 0
    @limit = limit
    @entry_station = nil
    @journeys = Journey.new
  end

  def top_up(amount)
    raise "Sorry, you've reached the limit of £#{@limit}" if @balance + amount > @limit
    @balance += amount
  end

  def touch_in(station)
    raise "Sorry, not enough credit in balance £#{@balance}" if @balance < MINIMUM_BALANCE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @entry_station = nil
    @journeys.journeys << {:entry_station => :station}
  end

  def in_journey?
    @entry_station !=nil
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
