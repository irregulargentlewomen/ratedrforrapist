require_relative 'api_handler'

class Person
  attr_reader :id
  attr_writer :api_key
  def initialize(id)
    @id = id
  end

  def movies
    @movies ||= get_movies
  end

  private
  include ApiHandler
  
  def get_movies
    response_body = get_unless_down
    response_body['cast'] + response_body['crew']
  end

  def url
    "http://api.themoviedb.org/3/person/#{id}/credits?api_key=#{api_key}"
  end
end
