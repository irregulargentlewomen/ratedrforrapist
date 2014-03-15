ENV['RACK_ENV'] ||= 'development'
require_relative 'lib/app_config'
require 'pry'


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
    DB[:movies].multi_insert(refresher.movies)
    DB[:roles].multi_insert(refresher.roles)
  end
  task :dump do
    DB = AppConfig.setup_db
    File.open('database_dump.yml', 'w') do |out|
      YAML.dump({
        'blacklist' => DB[:blacklist].to_hash(:id),
        'movies' => DB[:movies].to_hash(:id),
        'roles' => DB[:roles].to_hash(:id)
      }, out)
    end
  end
  task :load => :reload_schema do
    ['blacklist', 'movies', 'roles'].each do |t|
      DB[t.to_sym].multi_insert(YAML.load_file('database_dump.yml')[t].values)
    end
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
