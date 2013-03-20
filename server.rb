require 'sinatra'
require 'sinatra/contrib'
require 'httparty'
require 'sequel'

require_relative 'lib/app_config'

DB = AppConfig.setup_db

require_relative 'lib/movie'
require_relative 'lib/movie_search_results'
require_relative 'lib/blacklist'

set :app_file, __FILE__
set :public_folder, File.dirname(__FILE__) + '/static'

get '/search' do
  if params[:title]
    search_results = MovieSearchResults.get(params['title'])
    if search_results.length < 1
      return json(error: 'no results found')
    elsif search_results.length > 1
      return json(disambiguate: search_results.map { |x|
        {title: "#{x.title} (#{x.year})", id: x.id}
      })
    end
    movie = Movie.new(search_results.first.id)
  elsif params[:id]
    movie = Movie.new(params[:id])
  else
    return json(error: 'please search by either movie title or movie id')
  end
  
  json({
    blacklisted: movie.has_blacklisted_cast_or_crew?,
    blacklisted_cast_and_crew: movie.blacklisted_cast_and_crew.map { |x|
      {id: x['id'], name: x['name'], role: x['job'] || x['character']}
    }
  })
end