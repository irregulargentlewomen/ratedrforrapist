require 'sequel'
require 'yaml'
require 'ostruct'

class AppConfig
  class << self
    def load!
      @config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config.yml'))[ENV['RACK_ENV']]
    end

    def api_key
      @config['api_key']
    end

    def database
      @db ||= OpenStruct.new(@config['database'])
    end

    def setup_db
      Sequel.mysql2(database.name,
        :user => database.user,
        :password => AppConfig.database.password,
        :host => AppConfig.database.host
      )
    end
  end
end

AppConfig.load!