class CreateAccountCookies < ActiveRecord::Migration
  def change
    create_table :account_cookies do |t|
      t.string :secret
      t.belongs_to :user
    end
    
    add_index :account_cookies, :secret, :unique => true
  end
end
