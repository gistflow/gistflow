class AddRecieveDailyReportsToSettings < ActiveRecord::Migration
  def change
    add_column :settings, :recieve_daily_reports, :boolean, :default => true
  end
end