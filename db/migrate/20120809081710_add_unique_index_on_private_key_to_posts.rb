class AddUniqueIndexOnPrivateKeyToPosts < ActiveRecord::Migration
  def change
    add_index :posts, :private_key, unique: true
  end
end
