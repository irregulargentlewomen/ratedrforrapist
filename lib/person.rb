require_relative 'api_handler'
require_relative 'movie'

Person = Struct.new(:id, :name) do
  attr_writer :api_key, :movie_source
  def initialize(id, options = {})
    super(id, options[:name])
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
            release_year: r[:release_year],
            title: r[:title] 
          } :
          false),
        role: r[:role] || ''
      }
    }
  end

  private
  include ApiHandler
  
  def get_movies
    response_body = get_unless_down
    (response_body['cast'] + response_body['crew']).collect {|x| Movie.new(x['id'], title: x['title'])}
  end

  def url
    "http://api.themoviedb.org/3/person/#{id}/credits?api_key=#{api_key}"
  end

end
