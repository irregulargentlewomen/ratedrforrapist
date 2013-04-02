ENV['RACK_ENV'] ||= 'development'
require_relative 'lib/app_config'

task :reload_schema do
  DB = AppConfig.setup_db
  require_relative 'db/reload_schema'
end

namespace :blacklist do
  task :refresh => :reload_schema do
    require 'httparty'
    require_relative 'lib/refresh_blacklist'
    refresher = RefreshBlacklist.new
    refresher.fetch!
    DB[:blacklist].multi_insert(refresher.results)
  end
  task :dump do
    DB = AppConfig.setup_db
    File.open('database_dump.yml', 'w') do |out|
      YAML.dump({
        'blacklist' => DB[:blacklist].to_hash(:id)
      }, out)
    end
  end
end
