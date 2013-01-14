require 'rack/test'
ENV['RACK_ENV'] = 'test'

require_relative '../server'

# setup test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false

def app
  Sinatra::Application
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

before(:all) do
  DB.
end