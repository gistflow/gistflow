class AddIsPrivateToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :is_private, :boolean, default: false
  end
end
