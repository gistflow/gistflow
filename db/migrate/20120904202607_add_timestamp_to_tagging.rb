class AddTimestampToTagging < ActiveRecord::Migration
  def change
    change_table :taggings do |t|
      t.timestamps
    end

    Tagging.update_all(:created_at => Time.now, :updated_at => Time.now)
  end
end