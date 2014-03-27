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

  def self.nth_week(n=0)
    events = self.upcoming_events
    events.select { |event| event.start_date.between?(Date.yesterday + (n*7), Date.today + ((n*7)+7)) }
  end

  def self.nth_month(n=0)
    events = self.upcoming_events
    events.select { |event| event.start_date.between?(Date.yesterday+(n*7), Date.today + ((n*30)+30)) }
  end

  def self.nth_year(n=0)
    events = self.upcoming_events
    events.select { |event| event.start_date.between?(Date.yesterday+(n*7), Date.today + 365 + (n * 365)) }
  end

end

