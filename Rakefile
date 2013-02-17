ENV['RACK_ENV'] ||= 'development'
require_relative 'lib/app_config'

task :reload_schema do
  DB = AppConfig.setup_db
  require_relative 'db/reload_schema'
end

task :refresh_blacklist => :reload_schema do
  require 'httparty'
  require_relative 'lib/refresh_blacklist'
  refresher = RefreshBlacklist.new
  refresher.fetch!
  DB[:blacklist].multi_insert(refresher.results)
end