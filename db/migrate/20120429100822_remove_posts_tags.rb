class RemovePostsTags < ActiveRecord::Migration
  def change
    drop_table :posts_tags
  end
end
