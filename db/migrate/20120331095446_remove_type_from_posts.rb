class RemoveTypeFromPosts < ActiveRecord::Migration
  def change
    remove_column :posts, :type, :string
  end
end