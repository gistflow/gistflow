class AddQuestionToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :question, :boolean
  end
end
