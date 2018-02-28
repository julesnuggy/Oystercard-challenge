require_relative 'station.rb'
require_relative 'journey.rb'

class Oystercard
  DEFAULT_LIMIT = 90
  MINIMUM_BALANCE = 1


  attr_accessor :balance


  def initialize(limit = DEFAULT_LIMIT, journey = Journey.new)
    @balance = 0
    @limit = limit
    @journey = journey
  end

  def top_up(amount)
    raise "Sorry, you've reached the limit of £#{@limit}" if @balance + amount > @limit
    @balance += amount
  end

  def touch_in(station)
    raise "Sorry, not enough credit in balance £#{@balance}" if @balance < MINIMUM_BALANCE
    @journey.start(station)
  end

  def touch_out(station)
    @journey.finish(station)
    deduct(@journey.fare)
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
