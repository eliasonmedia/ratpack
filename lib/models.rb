# -*- encoding : utf-8 -*-
class RatPackModel 
  def present(controller, options = {})
    klass ||= "#{self.class}Presenter".constantize
    klass.new(self, controller, options)
  end
end
class User < RatPackModel 
  include Mongoid::Document  
  include Mongoid::Timestamps
  field :first_name, type: String
  field :last_name, type: String
  field :username, type: String
  field :email, type: String
end

