require 'json'
module ApiHandler
  def self.included(base)
    base.class_eval do
      attr_writer :api_key
    end
  end

  def api_key
    @api_key ||= AppConfig.api_key
  end

  def get_unless_down
    5.times do |i|
      response = HTTParty.get(url)
      if response.code == 200
        return JSON.parse(response.body)
      end
    end
    raise 'api down'
  end

  def url
    raise 'must be defined in implementing class'
  end
end