# -*- encoding : utf-8 -*-
require 'rubygems'
require 'bundler'

Bundler.require
require 'bundler/setup'
require 'sinatra'
require 'sinatra/content_for'
require 'active_support'
CONFIG = YAML::load_file(File.join(File.dirname(__FILE__),  'config.yml'))[ENV['RACK_ENV']].symbolize_keys
require  File.join(File.dirname(__FILE__), 'lib/symbolize_keys')
require  File.join(File.dirname(__FILE__), 'lib/models')
require  File.join(File.dirname(__FILE__), 'lib/presenters')
require  File.join(File.dirname(__FILE__), 'lib/jobs')
require  File.join(File.dirname(__FILE__), 'lib/partials')
require  File.join(File.dirname(__FILE__), 'lib/mailers')
class RatPack < Sinatra::Base

end

require  File.join(File.dirname(__FILE__), 'lib/config')
require  File.join(File.dirname(__FILE__), 'lib/controllers')


