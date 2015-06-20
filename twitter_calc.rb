class TwitterCalc

  require 'twitter'
  require 'yaml'

  def self.perform
    work
  end

  def self.work
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
          puts "searching #{l} #{term}"
          search = client.search("#{l} #{term}", result_type: "recent")
          results["#{line.first}"] = results["#{line.first}"] + search.to_a.keep_if {|t| t.created_at > Time.now - 60 * 15}.count
        rescue Twitter::Error::TooManyRequests => error
          if num_attempts <= max_attempts
            sleep error.rate_limit.reset_in
            retry
          else
            raise
          end
        end
      end
    end
    File.open('./tmp/results.yml', 'w') {|f| f.write results.to_yaml }
  end

end