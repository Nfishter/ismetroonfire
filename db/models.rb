require 'sequel'
require 'sinatra/sequel'

Sequel::Model.db=ENV['DATABASE_URL']

class Incidents < Sequel::Model
end
