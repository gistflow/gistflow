class AddTimestampToTag < ActiveRecord::Migration
  def change
    change_table :tags do |t|
      t.timestamps
    end

    Tag.update_all(:created_at => Time.now, :updated_at => Time.now)
  end
end