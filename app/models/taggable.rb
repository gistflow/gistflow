module Taggable
  include Replaceable::Taggable
  
  def self.included(base)
    base.class_eval do
      has_and_belongs_to_many :tags
      
      scope :tagged_with, lambda {
        |names| joins(:tags).where(:tags => { :name => names }).uniq
      }
      
      after_create :assign_tags
      after_create :increment_tags_counter_cache
      before_destroy :decrement_tags_counter_cache
    end
  end
  
  def assign_tags
    new_tag_ids = self.tag_names.map do |name|    
      Tag.find_or_create_by_name(name).id
    end
    
    self.tag_ids = new_tag_ids
  end
  
  def increment_tags_counter_cache
    self.update_posts_counts
  end

  def decrement_tags_counter_cache
    self.update_posts_counts(-1)
  end
  
  def update_posts_counts(by = 1)
    original_value_sql = "CASE WHEN 'posts_count' IS NULL THEN 0 ELSE 'posts_count' END"
    self.tags.update_all("'posts_count' = #{original_value_sql} + #{by.to_i}")
  end
end