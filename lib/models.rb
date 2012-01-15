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
  field :facebook_id, type: Integer
  field :auth_token, type: String
  field :username, type: String
  field :email, type: String
  field :last_email_sent, type: Date
  validates_presence_of :auth_token
  validates_presence_of :facebook_id
  validates_uniqueness_of :facebook_id
  has_and_belongs_to_many :friends, class_name: 'FacebookPerson', inverse_of: :friends_of
  has_and_belongs_to_many :friends_of, class_name: 'FacebookPerson', inverse_of: :friends
  embeds_one :status_update
  after_destroy :enqueue_delete_from_tables_job
end
