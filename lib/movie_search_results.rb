require_relative 'api_handler'
require_relative 'date_helper'
require 'delegate'
class MovieSearchResults < SimpleDelegator
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
    "http://api.themoviedb.org/3/search/movie?query=#{search_title}&api_key=#{api_key}"
  end

  class Result
    include DateHelper

    attr_reader :title, :id
    def initialize(attrs)
      @title = attrs['title']
      @id = attrs['id']
      @release_date = parse_date(attrs['release_date'])
    end

    def year
      @release_date ? @release_date.strftime("%Y") : 'unknown year'
    end
  end
end