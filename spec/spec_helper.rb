require 'ostruct'
require 'pry'

require 'mocha/api'
RSpec.configure { |c| c.mock_with :mocha }

module HTTParty; end
class AppConfig; def self.api_key; 'key'; end; end