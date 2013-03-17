require_relative 'api_handler'

class Movie
  attr_reader :id
  attr_writer :api_key
  def initialize(id)
    @id = id
  end

  def has_blacklisted_cast_or_crew?
    blacklisted_cast_and_crew.length > 0
  end

  def blacklisted_cast_and_crew
    @blacklisted_cast_and_crew ||= cast_and_crew.select {|x| ids_of_blacklisted_cast_and_crew.include? x['id']}
  end

  def cast_and_crew
    @cast_and_crew ||= api_response_body['cast'] + api_response_body['crew']
  end

  def release_year
  end

  private
  include ApiHandler
  
  def api_response_body
    @api_response_body ||= get_unless_down
  end

  def ids_of_blacklisted_cast_and_crew
    @ids_of_blacklisted_cast_and_crew ||= Blacklist.filtered_by_id(cast_and_crew.map {|x| x['id']}).select_map(:id)
  end

  def url
    "http://api.themoviedb.org/3/movie/#{id}/casts?api_key=#{api_key}"
  end
end
