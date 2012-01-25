class CreateGists < ActiveRecord::Migration
  def change
    create_table :gists do |t|
      t.references :user
      t.references :source, :polymorphic => true
      t.references :github
    end
  end
end
