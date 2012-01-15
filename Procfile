web: bundle exec thin start -p $PORT -e $RACK_ENV
worker:  QUEUE=* VERBOSE=TRUE bundle exec rake resque:work 
