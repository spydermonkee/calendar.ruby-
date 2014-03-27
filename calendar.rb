require 'bundler/setup'
Bundler.require(:default)
require 'date'


Dir[File.dirname(__FILE__) + '/lib/*.rb'].each { |file| require file }

ActiveRecord::Base.establish_connection(YAML::load(File.open('./db/config.yml'))["development"])

def welcome
  system('clear')
  puts "Welcome to the Calendar Program!"
  puts "Enter any key to continue."
  gets.chomp
  main_menu
end

def main_menu
  system('clear')
  puts "Enter 'a' to add an event."
  puts "Enter 'l' to list events."
  puts "Enter 'u' to update an event."
  puts "Enter 'x' to exit the program."
  case gets.chomp.downcase
  when 'a'
    add_menu
  when 'l'
    list_menu
  when 'u'
    update_menu
  when 'x'
    puts "Thank you, come again!"
    exit
  else
    puts "That is not a valid input, ya dingus."
    main_menu
  end
end

def add_menu
  puts "Please enter the start date:"
  puts "What is the year?"
  start_year = gets.chomp
  puts "What is the month? Please enter as a word."
  start_month = gets.chomp
  puts "What is the day?"
  start_day = gets.chomp
  puts "What time is this event starting?"
  start_time = gets.chomp
  start_date = DateTime.parse("#{start_day} #{start_month} #{start_year} #{start_time}")
  puts "Would you like to specify an end date and time for this event? y/n"
  end_time_choice = gets.chomp
  if end_time_choice == 'y'
    puts "Please enter the end date:"
    puts "What is the year?"
    end_year = gets.chomp
    puts "What is the month? Please enter as a word."
    end_month = gets.chomp
    puts "What is the day?"
    end_day = gets.chomp
    puts "What time is this event ending?"
    end_time = gets.chomp
    end_date = DateTime.parse("#{end_day} #{end_month} #{end_year} #{end_time}")
  end
  puts "What is the description of this event?"
  description_input = gets.chomp
  puts "Where is this event located?"
  location_input = gets.chomp
  this_event = Event.create(:description => description_input, :location=> location_input, :start_date => start_date, :end_date => end_date)
  if this_event.valid?
    puts "Your event has been created in your Calendar.
    Would you like to add another event? y/n"
    user_choice = gets.chomp
    if user_choice == 'y'
      add_menu
    else
      main_menu
    end
  else
    this_event.errors.full_messages.each { |message| puts message}
    add_menu
  end
end

def list_menu
  puts "do you want to see your upcoming calendar by all, today, week, month, or year?"
  choice = gets.chomp.downcase
  case choice
  when 'all'
    view_choice("upcoming_events")
  when 'today'
    view_choice("today")
  when 'week'
    view_choice("this_week")
  when 'month'
    view_choice("this_month")
  when 'year'
    view_choice("this_year")
  else
    puts 'Please enter a valid choice'
    list_menu
  end
end

def view_choice(choice)
  Event.send(choice).each { |event| puts "#{(event.start_date).to_formatted_s(:long_ordinal)}" }
  puts "Enter any key to go back to main menu."
  gets.chomp
  main_menu
end


welcome
