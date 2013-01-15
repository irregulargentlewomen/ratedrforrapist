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

post '/search' do
  if params[:id]
    result = {
      blacklisted: Movie.new(params[:id]).has_blacklisted_cast_or_crew?
    }
  else
    result = {
      disambiguate: MovieSearchResults.get(params['title']).map { |x|
        {title: "#{x.title} (#{x.year})", id: x.id}
      }
    }
  end

  json result
end