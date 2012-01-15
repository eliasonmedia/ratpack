# -*- encoding : utf-8 -*-
require File.dirname(__FILE__) + '/spec_helper'

describe "Jobs" do
  include Rack::Test::Methods

  def app
    @app ||= RatPack 
  end
  describe CleanupTablesJob, :vcr do 
    before do
     @results =  CleanupTablesJob.perform('4e5f8f1d7fcaa00002000001')
    end
    it "should have a good response" do
      @results.length.should == 120
    end
  end
end

