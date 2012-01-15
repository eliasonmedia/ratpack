# -*- encoding : utf-8 -*-

class RatPack< Sinatra::Base
  logobj = (ENV['RACK_ENV'] =~ /test/) ? File.open("log/#{ENV['RACK_ENV']}.log",'w') : STDOUT
  $log = Logger.new(logobj, development? ? :info : :warn ) 
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
    redis_uri = URI.parse(ENV["REDISTOGO_URL"].present? ? ENV["REDISTOGO_URL"] : CONFIG[:redis_uri])
    redis_path = redis_uri.path.gsub(/\//,'')
    Resque.redis = Redis.new(:host => redis_uri.host, :port => redis_uri.port, :password => redis_uri.password, :db => redis_path.empty? ? '0' : redis_path)

    use Rack::Session::Cookie, :key => 'rack.session',
      :path => '/',
      :expire_after => 2592000,
      :secret => 'soc333ialfoogo' 
    use OmniAuth::Builder do
      provider :facebook, CONFIG[:facebook_app_id], CONFIG[:facebook_app_secret], { :scope => 'email, publish_stream, offline_access, friends_education_history, user_education_history' }
    end
    enable :logging
    set :root, File.join(File.dirname(__FILE__), '..') 
    set :views, File.join(settings.root, 'views') 
    set :sass, :style => :compressed
    set :haml, :format => :html5
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
    # settings.sprockets.precompile([ /\w+\.(?!js|css).+/, /application.(css|js)$/ ])

    set :email_from_address, CONFIG[:email]["from_address"] 
    Pony.options = {
      :via => :smtp,
      :via_options => {
      :authentication => :plain,
      :enable_starttls_auto => true
    }.merge(CONFIG[:email]["via"].symbolize_keys) }

  end
  helpers Sinatra::ContentFor
  helpers do
    include Sinatra::Partials
    include Rack::Utils
    alias_method :h, :escape_html
  end 

end

