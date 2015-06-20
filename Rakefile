# Resque tasks
require 'resque'
require 'resque/tasks'
require 'resque/scheduler/tasks'

namespace :resque do
  task :setup do
    require 'resque'
    Resque.redis = 'localhost:6379'
  end

  task :setup_schedule => :setup do
    require 'resque-scheduler'
    load './twitter_calc.rb'
    Resque.schedule = {'calculate' => {"cron" => "* * * * *", 
                                       "queue" => "cron", 
                                       "class" => "TwitterCalc", 
                                       "description" => "Calculates stats"} }
  end

  task :scheduler => :setup_schedule
end