require 'sinatra'

set :app_file, __FILE__
set :public_folder, File.dirname(__FILE__) + '/static'

get '/'  do
  
end