class AddPrivateKeyToPost < ActiveRecord::Migration
  def change
    add_column :posts, :private_key, :string
  end
end
