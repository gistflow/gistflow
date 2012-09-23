class CreateAccountTokens < ActiveRecord::Migration
  def change
    create_table :account_tokens do |t|
      t.integer :user_id
      t.string :token
    end
    
    add_index :account_tokens, :token, unique: true
    add_index :account_tokens, :user_id, unique: true
  end
end
