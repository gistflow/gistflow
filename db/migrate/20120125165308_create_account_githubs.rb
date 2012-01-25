class CreateAccountGithubs < ActiveRecord::Migration
  def change
    create_table :account_githubs do |t|
      t.string :token
      t.references :github
      t.references :user
    end
    
    add_index :account_githubs, :token, :unique => true
    add_index :account_githubs, :github_id, :unique => true
  end
end
