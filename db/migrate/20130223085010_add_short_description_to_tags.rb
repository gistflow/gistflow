class AddShortDescriptionToTags < ActiveRecord::Migration
  def change
    add_column :tags, :short_description, :string
  end
end
