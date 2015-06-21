class TwitterCalc

  require 'twitter'
  require 'pg'
  require 'sequel'
  
  def self.perform
    work
  end

  def self.work

    Sequel.connect(ENV['DATABASE_URL'])
    require './db/models'

    client = Twitter::REST::Client.new do |config|
      config.consumer_key        = ENV['TWITTER_API_KEY']
      config.consumer_secret     = ENV['TWITTER_API_SECRET']
      config.access_token        = ENV['TWITTER_MY_ACCESS_TOKEN']
      config.access_token_secret = ENV['TWITTER_MY_ACCESS_SECRET']
    end

    results = Hash.new
    lines = [ %w{red rd} ,  %w{orange or} ,  %w{blue bl} ,  %w{silver sv} ,  %w{green gr} ,  %w{yellow yl} ]
    terms = %w{ unsuckdcmetro wmata }
    heats = %w{ fire smoke }
    searches = terms.product(heats).map{|k| k.join(' ') }

    lines.product(searches).each do |line, term| 
      results["#{line.first}"] = 0
      line.each do |l|  
        max_attempts = 3
        num_attempts = 0
        begin
          num_attempts += 1
          search = client.search("#{l} #{term}", result_type: "recent", count: 100)
          results["#{line.first}"] = results["#{line.first}"] + search.to_a.keep_if {|t| t.created_at > Time.now - 60 * 60}.count
        rescue Twitter::Error::TooManyRequests => error
          if num_attempts <= max_attempts
            sleep error.rate_limit.reset_in
            retry
          else
            raise error
          end
        end
      end
    end
    puts results
    bad_lines = results.map{|k,v| k if v > 5}.delete_if{|a| a.nil?}
    if !bad_lines.empty?
      openings = ["Oh shit. ", "Conflabbit! ", "Just great. ", "Nuts. "]
      bad_lines.each{|l| client.update("#{openings.sample} The #{l} line is on fire.") }
    end
    Incident.insert(:red => results['red'], :yellow => results['yellow'], :orange => results['orange'], :blue => results['blue'], :silver => results['silver'], :green => results['green'], :created_at => Time.now)
  end

end