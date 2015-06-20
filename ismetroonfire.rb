require 'rack-google-analytics'
require 'sinatra'
require 'sinatra/json'
require 'yaml'

use Rack::GoogleAnalytics, :tracker => ENV['GA_TRACKING_ID']

get '/' do
  erb :index 
end

get '/fireapi' do
  json YAML.load_file('./tmp/results.yml')
end

get '/yes' do
  message = ["It looks like it", 
             "Twitter says yes",
             "Why, yes it is!",
             "I'm afraid so"].sample
  json  message: message
end


get '/no' do
  message = ["Suprisingly, no", 
		     "Nope!",
		     "Doesn't look like it",
		     "No"].sample
  json	message: message
end