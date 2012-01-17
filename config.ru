require 'rubygems'
require 'bundler'

Bundler.require
require 'bundler/setup'
ENV['RACK_ENV'] = 'development' if ENV['RACK_ENV'].nil?
require './app'

root =  File.join(File.dirname(__FILE__), '..') 

map "/assets" do
   run RatPack.sprockets
 end

map "/" do
  run RatPack 
end
