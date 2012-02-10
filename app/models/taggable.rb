module Taggable
  def self.included(base)
    base.class_eval do
      has_and_belongs_to_many :tags
      
      scope :tagged_with, lambda {
        |names| joins(:tags).where(:tags => { :name => names }).uniq
      }
      
      after_create :assign_tags
    end
  end
  
  def assign_tags
    new_tag_ids = self.tag_names.to_s.split(',').compact.map{ |name|
      Tag.find_or_create_by_name(name.strip.gsub(' ', '_')).id
    }
    
    self.tag_ids = new_tag_ids
  end
end