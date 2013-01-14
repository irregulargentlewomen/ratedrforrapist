class AppConfig
  class << self
    def load!
      @config = YAML.load_file('config.yml')[ENV['RACK_ENV']]
    end

    def api_key
      @config['api_key']
    end
  end
end

AppConfig.load!