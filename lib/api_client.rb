require 'json'
require 'movie'
require 'collaboration'
require 'person'

class ApiClient
  class ApiNotAvailableError < StandardError; end
  attr_reader :api_key, :http_client

  def initialize(options = {})
    @api_key = options.fetch(:api_key, AppConfig.api_key)
    @http_client = options.fetch(:http_client, HTTParty)
  end

  def cast_and_crew_for_movie(movie)
    response = http_client.get(
      "#{base_url}/movie/#{movie.id}",
      query: {key: api_key, append_to_response: 'casts'},
      headers: {'Accept' => 'application/json'}
    )
    raise ApiNotAvailableError unless response.code == 200
    parsed_response = JSON.parse(response.body)
    (parsed_response['cast'] + parsed_response['crew']).map do |person_json|
      Collaboration.new(
        person: Person.new(
          id: person_json['id'],
          name: person_json['name']
          ),
        role: (person_json['character'] || person_json['job']),
        movie: movie
      )
    end
  end

  private
  def base_url
    'http://api.themoviedb.org/3/'
  end
end