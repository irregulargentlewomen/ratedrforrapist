require_relative 'api_handler'
require 'date'
require 'delegate'
class PersonSearchResults < SimpleDelegator
  def self.get(title)
    new(title)
  end

  attr_reader :search_name

  def initialize(name)
    @search_name = name
    results = get_unless_down['results']
    super(
      results.map { |r|
        Result.new(r)
      }
    )
  end

  private
  include ApiHandler

  def url
    "http://api.omdb.org/3/search/person?query=#{search_title}&api_key=#{api_key}"
  end

  class Result
    attr_reader :name, :id
    def initialize(attrs)
      @name = attrs['name']
      @id = attrs['id']
    end
  end
end