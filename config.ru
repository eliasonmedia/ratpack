require 'rubygems'
require 'bundler'

Bundler.require
require 'bundler/setup'
require 'ruby-debug' if $DEBUG
ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?
require 'resque/server'
require './app'
require 'rack/cache'

root =  File.join(File.dirname(__FILE__), '..') 


use Rack::Static, :urls => ["/stylesheets", "/images", "/javascripts"], :root => "public"
run Rack::URLMap.new \
  "/assets" => RatPack.sprockets, 
  "/"       => RatPack.new

  #"/resque" => Resque::Server.new,
