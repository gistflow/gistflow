class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username
      t.string :name
      t.string :email
      t.string :home_page
      t.string :github_page
      t.string :gravatar_id
      t.timestamp :created_at
    end
  end
end
