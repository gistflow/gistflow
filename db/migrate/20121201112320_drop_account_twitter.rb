class DropAccountTwitter < ActiveRecord::Migration
  def change
    drop_table :account_twitters
  end
end
