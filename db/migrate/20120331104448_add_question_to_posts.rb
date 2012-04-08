class AddQuestionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :question, :boolean, :default => false
  end
end
