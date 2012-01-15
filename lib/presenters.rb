# -*- encoding : utf-8 -*-
#Cribbed off Ryan Bates' Presenters Railscast
class BasePresenter
  def initialize(object, controller, options = {})
    @object = object
    @controller = controller
    @options = options
  end
  def options
    @options
  end
  def id
    @object.id.to_s
  end
  private

  def self.presents(name)
    define_method(name) do
      @object
    end
  end

  def h
    @controller
  end

  def method_missing(*args, &block)
    @controller.send(*args, &block)
  end
end

class UserPresenter < BasePresenter 
  presents :user
  delegate :first_name, :last_name, :facebook_id, :username, :email, :'[]', to: :user
  def facebook_image_url(size='square')
    "https://graph.facebook.com/#{self.facebook_id}/picture?type=#{size}" 
  end
  def name
    "#{@object.first_name} #{@object.last_name[0]}."
  end
end

