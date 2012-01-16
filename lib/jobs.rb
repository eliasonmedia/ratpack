# -*- encoding : utf-8 -*-
require 'csv'
class CleanupTablesJob < Resque::Job
  @queue = :util
  def self.perform(user_id)
  end
end
