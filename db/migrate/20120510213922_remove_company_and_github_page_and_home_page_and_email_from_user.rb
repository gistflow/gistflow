class RemoveCompanyAndGithubPageAndHomePageAndEmailFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :company
    remove_column :users, :github_page
    remove_column :users, :email
    remove_column :users, :home_page
  end
end