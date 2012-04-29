class Tagging < ActiveRecord::Base
  belongs_to :tag, counter_cache: true
  belongs_to :taggable
  # attr_accessible :title, :body
end
