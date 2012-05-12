class RemoveGithubPageFromProfiles < ActiveRecord::Migration
  def change
    remove_column :profiles, :github_page
  end
end