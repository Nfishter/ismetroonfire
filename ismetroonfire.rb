require 'sinatra'
require "sinatra/json"
require 'twitter'

get '/' do
  erb :index 
end

get '/twitter' do
  json(twitter)
end

helpers do
  def twitter
    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = ENV['TWITTER_MY_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_MY_ACCESS_SECRET']
    end

    hashtags = %w{tbt}
    begin
      client.search("to:unsuckdcmetro", result_type: "recent").take(20).map{|tweet| {:username => tweet.user.screen_name, :tweet => tweet.text} }
    rescue Twitter::Error::TooManyRequests => error
      sleep error.rate_limit.reset_in + 1
      retry
    end
  end
end