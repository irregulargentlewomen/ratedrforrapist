require 'sinatra'
require 'sinatra/contrib'
require 'httparty'
require 'sequel'

require_relative 'lib/app_config'

DB = AppConfig.setup_db

require_relative 'lib/movie'
require_relative 'lib/movie_search_results'
require_relative 'lib/blacklist'
require_relative 'lib/person'

set :app_file, __FILE__
set :public_folder, File.dirname(__FILE__) + '/static'

get '/' do
  send_file File.join(settings.public_folder, 'index.html')
end

get '/search/:title.json' do
  search_results = MovieSearchResults.get(params['title'])
  return json(search_results.map { |x|
    {
      id: x.id,
      title: x.title,
      releaseYear: x.year
    }
  })
end

get '/movies/:id.json' do
  movie = Movie.new(params[:id])

  json({
    movie: {
      id: movie.id,
      title: movie.title,
      releaseYear: movie.release_year
    },
    people: movie.presentable_blacklisted_cast_and_crew
  })
end