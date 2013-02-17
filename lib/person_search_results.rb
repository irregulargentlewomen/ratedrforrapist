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
    super(results.map {|r| { 'id' => r["id"], 'name' => r['name']} })
  end

  private
  include ApiHandler

  def url
    "http://api.themoviedb.org/3/search/person?query=#{search_name}&api_key=#{api_key}"
  end
end