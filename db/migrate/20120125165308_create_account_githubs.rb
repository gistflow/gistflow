class CreateAccountGithubs < ActiveRecord::Migration
  def change
    create_table :account_githubs do |t|
      t.string :token
      t.references :user
    end
    
    add_index :account_githubs, :token, :unique => true
  end
end
