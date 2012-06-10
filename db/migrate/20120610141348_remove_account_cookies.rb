class RemoveAccountCookies < ActiveRecord::Migration
  def change
    drop_table :account_cookies
  end
end
