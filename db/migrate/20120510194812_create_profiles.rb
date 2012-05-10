class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.string :email
      t.string :company
      t.string :home_page
      t.string :github_page
      t.references :user
      t.timestamps
    end
  end
end
