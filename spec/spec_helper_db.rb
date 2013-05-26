require 'database_cleaner'

ENV['RACK_ENV'] = 'test'
require_relative '../lib/app_config'

# only run once
unless defined? DB
  DB = AppConfig.setup_db
  require_relative '../db/reload_schema.rb'
end

RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end