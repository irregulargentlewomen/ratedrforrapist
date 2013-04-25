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
    DB[:roles].multi_insert(refresher.roles)
  end
  task :dump do
    DB = AppConfig.setup_db
    File.open('database_dump.yml', 'w') do |out|
      YAML.dump({
        'blacklist' => DB[:blacklist].to_hash(:id)
      }, out)
    end
  end
  task :load => :reload_schema do
    DB[:blacklist].multi_insert(YAML.load_file('database_dump.yml')['blacklist'].values)
  end
end

begin
  require 'jasmine'
  load 'jasmine/tasks/jasmine.rake'
rescue LoadError
  task :jasmine do
    abort "Jasmine is not available. In order to run jasmine, you must: (sudo) gem install jasmine"
  end
end
