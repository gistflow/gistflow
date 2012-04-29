class SetupTagsCounterCaches < ActiveRecord::Migration
  def change
    remove_column :tags, :posts_count
    remove_column :tags, :comments_count
    add_column :tags, :taggings_count, :integer, default: 0
  end
end
