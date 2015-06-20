require 'rack-google-analytics'
require 'sinatra'
require 'sinatra/json'
require 'sequel'
require 'sinatra/sequel'

set :database, ENV['DATABASE_URL']
require './db/models'

use Rack::GoogleAnalytics, :tracker => ENV['GA_TRACKING_ID'] if ENV["RACK_ENV"] == 'production'

get '/' do
  erb :index 
end

get '/fireapi' do
  results = Hash.new
  recent = Incident.last
  %w{red orange yellow green blue silver}.each do |line|
    results["#{line}"] = recent.send(line) || 0
  end
  json results
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
   json  message: message
end