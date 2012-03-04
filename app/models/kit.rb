class Kit < ActiveRecord::Base
  GROUPS = { 0 => :Languages, 1 => :Frameworks, 2 => :Topics }
  
  has_and_belongs_to_many :tags
  has_and_belongs_to_many :users
  
  validates :name, :presence => true
  
  scope :sorted, order('group_position, position')
  
  def group
    GROUPS[group_position]
  end
end
