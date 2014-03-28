require 'spec_help'

describe Event do
  it 'validates a description is present' do
    event = Event.create(:description => "")
    event.should_not be_valid
  end

  it 'validates that a start date is present' do
    event = Event.create(:description => "this event is awwesome!!!!", :start_date => "2014/08/01")
    event.should be_valid
  end

  describe '.upcoming_events' do
    it 'sorts all upcoming events by start date' do
      old_event = Event.create(:description => "old event", :start_date => "2005/04/04")
      new_event = Event.create(:description => "new event", :start_date => "2017/07/03")
      Event.upcoming_events.should eq [new_event]
    end
  end

  describe '.today' do
    it 'lists the events upcoming for today' do
      event1 = Event.create(:description => "old event", :start_date => "2014/03/27 19:30:00")
      event2 = Event.create(:description => "2nd old event", :start_date => "2014/03/27 19:35:00")
      Event.today.should eq [event1, event2]
    end
  end

  describe '.nth_week' do
    it 'lists the events upcoming for the current week' do
      event1 = Event.create(:description => "old event", :start_date => "2014/03/30 19:30:00")
      event2 = Event.create(:description => "2nd old event", :start_date => "2014/03/31 19:35:00")
      event3 = Event.create(:description => "3rd old event", :start_date => "2014/04/25 19:35:00")
      Event.nth_week.should eq [event1, event2]
    end

  end

  describe '.nth_month' do
    it 'lists the events upcoming for current month' do
      event1 = Event.create(:description => "old event", :start_date => "2014/03/30 19:30:00")
      event2 = Event.create(:description => "2nd old event", :start_date => "2014/04/16 19:35:00")
      event3 = Event.create(:description => "3rd old event", :start_date => "2014/05/25 19:35:00")
      Event.nth_month.should eq [event1, event2]
    end

    it 'lists the events upcoming for nth month into the future' do
      event1 = Event.create(:description => "old event", :start_date => "2014/03/30 19:30:00")
      event2 = Event.create(:description => "2nd old event", :start_date => "2014/03/31 19:35:00")
      event3 = Event.create(:description => "3rd old event", :start_date => "2014/05/10 19:35:00")
      Event.nth_month(1).should eq [event3]
    end
  end

  describe '.nth_year' do
    it 'lists the events upcoming for the current year' do
      event1 = Event.create(:description => "old event", :start_date => "2014/03/30 19:30:00")
      event2 = Event.create(:description => "2nd old event", :start_date => "2015/02/16 19:35:00")
      event3 = Event.create(:description => "3rd old event", :start_date => "2018/05/25 19:35:00")
      Event.nth_year.should eq [event1, event2]
    end
  end

  describe '.view_next' do
    it 'shows all the events in the next month depending on which month currently viewed' do
      view_date = Date.today
      event1 = Event.create(:description => "old event", :start_date => "2014/04/15 19:30:00")
      Event.view_next(view_date, "month").should eq [event1]
    end
  end

end
