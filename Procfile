web: bundle exec puma -t 5:5 -p ${PORT:-3000} -e ${RACK_ENV:-development}
worker: QUEUE=* bundle exec rake resque:work -r ./twitter_calc.rb
scheduler: bundle exec rake resque:scheduler