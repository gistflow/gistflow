class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :likable, :polymorphic => true
  
  validates :user_id, :uniqueness => { :scope => [:likable_id, :likable_type] }
  
  
  validates_each :user_id do |record, attr, value|
    record.errors.add attr, 'self like is prohibited' if record.likable_type.constantize.find(record.likable_id).user_id == value
  end
end
