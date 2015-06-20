class TwitterCalc

  def self.perform
    work
  end

  def self.work
    File.open('/tmp/resque', 'w') { |file| file.write(Time.now.to_s) }
  end

end




# client = Twitter::REST::Client.new do |config|
#   config.consumer_key        = ENV['TWITTER_API_KEY']
#   config.consumer_secret     = ENV['TWITTER_API_SECRET']
#   config.access_token        = ENV['TWITTER_MY_ACCESS_TOKEN']
#   config.access_token_secret = ENV['TWITTER_MY_ACCESS_SECRET']
# end

# results = Hash.new

# lines = [ %w{red rd} ,  %w{orange or} ,  %w{blue bl} ,  %w{silver sv} ,  %w{green gr} ,  %w{yellow yl} ]
# terms = %w{ @wmata @unsuckdcmetro #wmata #drgridlock}
# heats = %w{ fire smoke fd }
# searches = terms.product(heats).map{|k| k.join(' ') }


# lines.product(searches).each do |line, term| 
#   line.each do |l| 
#     max_attempts = 3
#     num_attempts = 0
#     begin
#       num_attempts += 1
#       results["#{line.first}"] = client.search("#{l} #{term}", result_type: "recent").take(100).to_a.keep_if {|t| t.created_at > Time.now - 60 * 240}.count
#     rescue Twitter::Error::TooManyRequests => error
#       if num_attempts <= max_attempts
#         sleep error.rate_limit.reset_in
#         retry
#       else
#         raise
#       end
#     end
#   end
# end