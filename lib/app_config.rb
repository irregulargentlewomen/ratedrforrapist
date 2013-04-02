require 'sequel'
require 'yaml'
require 'ostruct'

class AppConfig
  class << self
    def load!
      if File.file? File.join(File.dirname(__FILE__), '..', 'config.yml'
        @config = YAML.load_file(File.join(File.dirname(__FILE__), '..', 'config.yml'))[ENV['RACK_ENV']]
      else
        @config = {
          'api_key' => ENV['API_KEY'],
          'database' => {
            'adapter' => ENV["DATABASE_ADAPTER"],
            'name' => ENV["DATABASE_NAME"],
            'user' => ENV["DATABASE_USER"],
            'password' => ENV["DATABASE_PASSWORD"],
            'host' => ENV["DATABASE_HOST"]
          }
        }
      )
    end
  end
end

AppConfig.load!
    end

    def api_key
      @config['api_key']
    end

    def database
      @db ||= OpenStruct.new(@config['database'])
    end

    def setup_db
      Sequel.send(
        database.adapter,
        database.name,
        :user => database.user,
        :password => AppConfig.database.password,
        :host => AppConfig.database.host
      )
    end
  end
end

AppConfig.load!