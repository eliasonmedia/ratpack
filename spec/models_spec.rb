# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe "models" do
  include Rack::Test::Methods
  def auth_token
    'AAADIyAl5kIkBAApM66ZBxcpZAJHV6ZA84szYmHncZC3ZCw6PiM25pqKDhfZBhehUZBEKgGCZAlpyiZCmBTqZAgY59h8dNmRwGZBmeAZD'
  end
  def facebook_id
    20010401
  end
  def app
    @app ||= RatPack 
  end
  describe User do 

  end
end
