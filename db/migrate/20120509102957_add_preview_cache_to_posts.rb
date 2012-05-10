class AddPreviewCacheToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :preview_cache, :text
  end
end
