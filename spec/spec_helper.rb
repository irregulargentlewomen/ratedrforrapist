require 'ostruct'
require 'pry'

require 'mocha/api'
require 'bourne'
RSpec.configure { |c| c.mock_framework = :mocha }

module HTTParty; end
class AppConfig; def self.api_key; 'key'; end; end