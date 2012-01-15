$LOAD_PATH.unshift File.dirname(__FILE__) + '/lib'
require 'rubygems'
require 'bundler'

Bundler.require
require 'bundler/setup'
require 'ruby-debug' if $DEBUG
ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?
require 'resque/server'
require './app'
require 'resque/tasks'

  task 'resque:setup' do
    require 'jobs' 
  end

