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
  yes = ["It looks like it","Twitter says yes","Yes","Unfortunatley","Yep","Why, yes it is!","I'm afraid so"]
  no = ["Suprisingly, no", "Nope!", "It is not", "Doesn't look like it", "No"] 
  flag = false
  %w{red orange yellow green blue silver}.each do |line|
    if recent.send(line) > 0
      results["#{line}"] = recent.send(line)
      flag = true
    else
      results["#{line}"] = 0
    end
  end
  json ({:counts => results, :message => (flag == true ? yes.sample : no.sample) } )
end