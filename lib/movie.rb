require 'json'

class Movie
  attr_reader :id
  attr_writer :api_key
  def initialize(id)
    @id = id
  end

  def cast_and_crew
    @cast_and_crew ||= get_cast_and_crew
  end

  private
  def api_key
    @api_key ||= Config.api_key
  end

  def get_cast_and_crew
    response_body = get_unless_down
    response_body['cast'] + response_body['crew']
  end

  def get_unless_down
    5.times do |i|
      response = HTTParty.get(url)
      if response.code == 200
        return JSON.parse(response.body)
      end
    end
    raise 'api down'
  end

  def url
    "http://api.omdb.org/3/movie/#{id}/casts?api_key=#{api_key}"
  end
end
