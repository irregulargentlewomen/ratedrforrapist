require 'sinatra'
require 'sinatra/contrib'
require 'httparty'

require_relative 'lib/app_config'
require_relative 'lib/search_results'

set :app_file, __FILE__
set :public_folder, File.dirname(__FILE__) + '/static'

post '/search' do
  json(disambiguate:
    SearchResults.get(params['title']).map { |x|
      {title: "#{x.title} (#{x.year})", id: x.id}
    }
  )
end