require 'bundler/setup'
Bundler.require(:default, :test)

Dir[File.dirname(__FILE__) + '/../lib/*.rb'].each { |file| require file }

ActiveRecord::Base.File.establish_connection(YAML::load(File.open('./db/config.yml'))["test"])

RSpec.configure do |config|
  config.before(:each) do
    Event.all.each {|event| event.destroy}
  end
end
