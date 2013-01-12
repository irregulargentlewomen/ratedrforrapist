require_relative 'api_handler'
require 'delegate'
class SearchResults < SimpleDelegator
  def self.get(title)
    new(title)
  end

  attr_reader :search_title

  def initialize(title)
    @search_title = title
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
    "http://api.omdb.org/3/search/movie?query=#{search_title}&api_key=#{api_key}"
  end

  class Result
    attr_reader :title, :id
    def initialize(attrs)
      @title = attrs['title']
      @id = attrs['id']
    end
  end
end