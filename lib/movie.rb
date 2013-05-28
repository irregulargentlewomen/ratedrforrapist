require_relative 'api_handler'

class Movie
  attr_reader :id
  attr_writer :api_key
  def initialize(id, params = {})
    @id = id
    @release_year = params[:release_year]
    @title = params[:title]
  end

  def has_blacklisted_cast_or_crew?
    blacklisted_cast_and_crew.length > 0
  end

  def blacklisted_cast_and_crew
    @blacklisted_cast_and_crew ||= cast_and_crew.select {|x| ids_of_blacklisted_cast_and_crew.include? x['id']}
  end

  def cast_and_crew
    @cast_and_crew ||= api_response_body['casts']['cast'] + api_response_body['casts']['crew']
  end

  def presentable_blacklisted_cast_and_crew
    blacklisted_cast_and_crew.inject({}) { |result, x|
      if result[x['id']]
        result[x['id']][:role] += ", #{x['job'] || x['character']}"
      else
        result[x['id']] = {id: x['id'], name: x['name'], role: x['job'] || x['character']}
      end
      result
    }.values
  end

  def release_year
    @release_year ||= DateTime.parse(api_response_body['release_date']).strftime("%Y")
  end

  def title
    @title ||= api_response_body['title']
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
    "http://api.themoviedb.org/3/movie/#{id}?api_key=#{api_key}&append_to_response=casts"
  end
end
