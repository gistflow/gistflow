class RemoveQuestionFromCommentsAndPosts < ActiveRecord::Migration
  def up
    remove_column :comments, :question
    remove_column :posts, :question
  end

  def down
    add_column :comments, :question, :boolean, default: false
    add_column :posts, :question, :boolean, default: false
  end
end
