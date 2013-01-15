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

require_relative '../db/reload_schema.rb'
DB[:blacklist].multi_insert(
  YAML.load_file(File.join(File.dirname(__FILE__), 'fixtures', 'blacklist.yml'))
)