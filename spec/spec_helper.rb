# -*- encoding : utf-8 -*-
ENV['RACK_ENV'] = 'test'

require File.join(File.dirname(__FILE__), '..', 'app.rb')

require 'rubygems'
require 'sinatra'
require 'rack/test'
require 'rspec'
require 'rspec/autorun'
require 'vcr'
require 'resque_spec'
RSpec.configure do |c|
  c.extend VCR::RSpec::Macros
  c.include Rack::Test::Methods
  c.before(:each) { FacebookPerson.delete_all; School.delete_all; ResqueSpec.reset! }
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr => true) do |example|
    name = example.metadata[:full_description].downcase.gsub(/\W+/, "_").split("_", 2).join("/")
    VCR.use_cassette(name, :record => :new_episodes) do
      example.call
    end
  end

end
VCR.config do |c|
  c.cassette_library_dir     = 'spec/cassettes'
  c.stub_with                :fakeweb
  c.default_cassette_options = { :record => :new_episodes }
end
class Rack::Session::Cookie
  def call(env)
    env['rack.session'] ||= {}
    @app.call(env)
  end
end
OmniAuth.config.test_mode = true
# set test environment
set :environment, :test
set :run, false
set :raise_errors, true
set :logging, false
set :sessions, false
@sean_oa_code = 'AQCXFiZE9EXxCyHTqlEDGzDRztxW1oVVUMixmoOm8vUBMfkkNmZBOCSOtdVNh4fn8KceFteqliC0xeFbSAwKlO_or2QoB1UF3eBHl05QXWeCZc7usdvuxlY9pZaDxpDRVJJnQyLFw7aGftznISDkLyGUSwEBsvx_Evf4o8LdefSlupJ8z4xHBxYsciX2aW84l8E'
SEAN_OA_HASH = {"provider"=>"facebook",
 "uid"=>"20010401",
 "credentials"=>
  {"token"=>
    "AAADIyAl5kIkBAApM66ZBxcpZAJHV6ZA84szYmHncZC3ZCw6PiM25pqKDhfZBhehUZBEKgGCZAlpyiZCmBTqZAgY59h8dNmRwGZBmeAZD"},
 "user_info"=>
  {"nickname"=>"mcculloughsean",
   "email"=>"mcculloughsean@gmail.com",
   "first_name"=>"Sean",
   "last_name"=>"McCullough",
   "name"=>"Sean McCullough",
   "image"=>"http://graph.facebook.com/20010401/picture?type=square",
   "urls"=>
    {"Facebook"=>"http://www.facebook.com/mcculloughsean", "Website"=>nil}},
 "extra"=>
  {"user_hash"=>
    {"id"=>"20010401",
     "name"=>"Sean McCullough",
     "first_name"=>"Sean",
     "last_name"=>"McCullough",
     "link"=>"http://www.facebook.com/mcculloughsean",
     "username"=>"mcculloughsean",
     "hometown"=>{"id"=>"112851398726841", "name"=>"Marmora, New Jersey"},
     "location"=>{"id"=>"108659242498155", "name"=>"Chicago, Illinois"},
     "education"=>
      [{"school"=>{"id"=>"112180615459883", "name"=>"Ocean City High School"},
        "year"=>{"id"=>"113125125403208", "name"=>"2004"},
        "type"=>"High School"},
       {"school"=>
         {"id"=>"104052199632591", "name"=>"Loyola University Chicago"},
        "type"=>"College"}],
     "gender"=>"male",
     "email"=>"mcculloughsean@gmail.com",
     "timezone"=>-5,
     "locale"=>"en_US",
     "languages"=>[{"id"=>"108513039169313", "name"=>"Latin"}],
     "verified"=>true,
     "updated_time"=>"2011-10-21T18:42:52+0000"}}}
