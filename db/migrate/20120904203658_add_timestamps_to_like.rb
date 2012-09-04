class AddTimestampsToLike < ActiveRecord::Migration
  def change
    change_table :likes do |t|
      t.timestamps
    end

    Like.update_all(:created_at => Time.now, :updated_at => Time.now)
  end
end