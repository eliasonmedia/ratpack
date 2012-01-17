# -*- encoding : utf-8 -*-

class RatPack< Sinatra::Base
  #### Logging
  logobj = (ENV['RACK_ENV'] =~ /test/) ? File.open("log/#{ENV['RACK_ENV']}.log",'w') : STDOUT
  $log = Logger.new(logobj, development? ? :info : :warn ) 
  
  #### ODM
  Mongoid.configure do |config|
    if ENV['RACK_ENV'] =~ /staging|production/
      uri = URI.parse(ENV['MONGOLAB_URI'])
      conn = Mongo::Connection.from_uri( ENV['MONGOLAB_URI'] ) 
      config.master = conn.db(uri.path.gsub(/^\//, ''))
      config.master.authenticate(uri.user, uri.password)
    else
      name = "rat_pack_#{ENV['RACK_ENV']}"
      host = "localhost"
      config.master = Mongo::Connection.new('localhost', 27017, logger: $log).db(name)
    end
  end
  Mongoid.logger = $log 


  configure do
    #### RACK SESSION
    use Rack::Session::Cookie, :key => 'rack.session',
      :path => '/',
      :expire_after => 92000,
      :secret => 'rasdawatpack' 
    enable :logging

    set :root, File.join(File.dirname(__FILE__), '..') 
    set :views, File.join(settings.root, 'views') 

    set :sass, :style => :compressed
    set :haml, :format => :html5
    

    #### SPROCKETS
    sprockets  = Sprockets::Environment.new(settings.root) do |sp|
      sp.logger.level = Logger::INFO
      sp.append_path(File.join(root, 'assets', 'stylesheets'))
      sp.append_path(File.join(root, 'assets', 'javascripts'))
      sp.append_path(File.join(root, 'assets', 'images'))
      if (ENV['RACK_ENV'] =~ /staging|production/)
        require "yui/compressor"
        sp.css_compressor =  YUI::CssCompressor.new
        sp.js_compressor =  YUI::JavaScriptCompressor.new
      else
        sp.css_compressor =  nil 
        sp.js_compressor =  nil 
      end
    end
    set :sprockets, sprockets

  end
  
  #### HELPERS
  helpers Sinatra::ContentFor
  helpers do
    include Rack::Utils
    alias_method :h, :escape_html
  end 

end


