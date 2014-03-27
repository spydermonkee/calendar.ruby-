class Event < ActiveRecord::Base
  validates :description, :presence => true
  validates :start_date, :presence => true

  def self.upcoming_events
    upcoming_events = self.where(:start_date => (Date.yesterday..(Time.now + 1000.year)))
    upcoming_events.sort_by! &:start_date
    upcoming_events
  end

  def self.today
    results = []
    todays_events = self.where(:start_date => Date.today..Date.tomorrow)
    todays_events.each { |event| results << event }
    results
  end

  def self.this_week
    events = self.upcoming_events
    events.select { |event| event.start_date.between?(Date.yesterday, Date.today + 6) }
  end

  def self.this_month
    events = self.upcoming_events
    events.select { |event| event.start_date.between?(Date.yesterday, Date.today + 30) }
  end
end

