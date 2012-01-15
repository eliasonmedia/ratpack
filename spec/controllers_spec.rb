# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe "My App" do
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
  describe "omniauth", :vcr do
    before do
      OmniAuth.config.add_mock(:facebook, SEAN_OA_HASH)
      get "/auth/facebook/callback"
    end
    it "Should redirect to /" do
      last_response.status.should == 302
    end
  end
  describe "homepage" do
    before do
      User.delete_all
    end
    describe "without a cookie" do

      it "should respond to /" do
        get '/'
        last_response.should be_ok
        last_response.headers["Content-Type"].should =~ /text\/html/
        last_response.body =~ /Welcome to RatPack/ 
      end
    end
    describe "with a cookie" do
      it "should respond to /" do
        @user = User.create(first_name: "test", facebook_id: 123445667, auth_token: 'abcd.efgh', username: 'test')
        get '/',params =  {}, rack_env = {session: { user_id: @user.id } } 
        last_response.body =~ /login/ 
      end
    end
  end

end
