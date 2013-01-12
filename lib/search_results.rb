require 'delegate'
require 'json'
class SearchResults < SimpleDelegator
  def self.get(title)
    new(title)
  end

  attr_reader :search_title

  def initialize(title)
    @search_title = title
    results = get_unless_down
    super(
      results.map { |r|
        Result.new(r)
      }
    )
  end

  private
  def api_key
    @api_key ||= AppConfig.api_key
  end

  def get_unless_down
    5.times do |i|
      response = HTTParty.get(url)
      if response.code == 200
        return JSON.parse(response.body)['results']
      end
    end
    raise 'api down'
  end

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