require_relative 'station.rb'
require_relative 'journey.rb'
require_relative 'journeylog.rb'

class Oystercard
  DEFAULT_LIMIT = 90
  MINIMUM_BALANCE = 1


  attr_accessor :balance


  def initialize(limit = DEFAULT_LIMIT, journeylog = JourneyLog.new)
    @balance = 0
    @limit = limit
    @journeylog = journeylog
  end

  def top_up(amount)
    raise "Sorry, you've reached the limit of £#{@limit}" if @balance + amount > @limit
    @balance += amount
  end

  def touch_in(station)
    raise "Sorry, not enough credit in balance £#{@balance}" if @balance < MINIMUM_BALANCE
    @journeylog.start(station)
  end

  def touch_out(station)
    @journeylog.finish(station)
    deduct(@journeylog.fare)
  end

  private
  def deduct(amount)
    @balance -= amount
  end
end
