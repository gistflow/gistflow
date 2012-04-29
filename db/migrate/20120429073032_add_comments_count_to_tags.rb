class AddCommentsCountToTags < ActiveRecord::Migration
  def change
    add_column :tags, :comments_count, :integer, default: 0
  end
end
