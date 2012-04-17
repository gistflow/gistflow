class CreateAccountTwitters < ActiveRecord::Migration
  def change
    create_table :account_twitters do |t|
      t.integer :user_id
      t.integer :twitter_id
      t.string :token
      t.string :secret
    end
    
    add_index :account_twitters, :user_id, :unique => true
  end
end
