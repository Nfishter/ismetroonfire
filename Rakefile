# Resque tasks
require 'resque/tasks'
require 'resque_scheduler/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    Resque.redis = 'localhost:6379'
  end

  task :setup_schedule => :setup do
    require 'resque_scheduler'
    Resque.schedule = {:calculate => {:cron => "*/10 * * * *", :queue => "cron", :class => "TwitterCalc", :args => "work" , :description => "Calculates stats"} }
    load './twitter_calc.rb'
  end

  task :scheduler => :setup_schedule
end