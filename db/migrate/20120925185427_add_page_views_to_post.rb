class AddPageViewsToPost < ActiveRecord::Migration
  def change
    add_column :posts, :page_views, :integer, :default => 1
  end
end
