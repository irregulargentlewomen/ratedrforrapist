require_relative 'api_handler'

class Person
  class << self
    attr_writer :movie_source
    def movie_source
      @movie_source ||= Movie.public_method(:new)
    end
  end

  attr_reader :id
  attr_writer :api_key
  def initialize(id)
    @id = id
  end

  def movies
    @movies ||= get_movies
  end

  def blacklist_roles
    DB[:roles].
      left_outer_join(:movies, id: :movie_id).
      where(person_id: id).
      map { |r|
      { movie: (r[:movie_id] ?
          {
            releaseYear: r[:release_year],
            title: r[:title] 
          } :
          false),
        role: r[:role] || '',
        source: r[:source] || ''
      }
    }
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
