# -*- encoding : utf-8 -*-
require 'csv'
require 'rpm_contrib/instrumentation/resque'
class CleanupTablesJob < Resque::Job
  @queue = :map
  def self.perform(user_id, google_username=CONFIG[:google_username], google_password=CONFIG[:google_password], tableid=CONFIG[:google_fusion_table_id], table_name=CONFIG[:google_fusion_table])
    ft = GData::Client::FusionTables.new
    ft.clientlogin(google_username,google_password)
    results = ft.execute("SELECT ROWID FROM #{tableid} WHERE user_id = '#{user_id}'")
    ids = results.collect {|r| r[:rowid]}
    ids.collect { |id| ft.execute("DELETE FROM #{tableid} WHERE ROWID='#{id}'") } 
  end
end
