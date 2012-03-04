class Kit < ActiveRecord::Base
  has_and_belongs_to_many :tags
  validates :name, :presence => true
  scope :sorted, order('group_position, position')
end
