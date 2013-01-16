require_relative 'api_handler'

class Movie
  attr_reader :id
  attr_writer :api_key
  def initialize(id)
    @id = id
  end

  def has_blacklisted_cast_or_crew?
    Blacklist.check(cast_and_crew.map {|x| x['id']})
  end

  def cast_and_crew
    @cast_and_crew ||= get_cast_and_crew
  end

  private
  include ApiHandler
  
  def get_cast_and_crew
    response_body = get_unless_down
    response_body['cast'] + response_body['crew']
  end

  def url
    "http://api.omdb.org/3/movie/#{id}/casts?api_key=#{api_key}"
  end
end
