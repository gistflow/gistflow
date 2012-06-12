module Models
  # Added mark_delete methods and prevent destroying record
  module Indestructible
    extend ActiveSupport::Concern
    
    included do
      # prevent destroy action if it called by accident
      before_destroy { false }
      
      # hide "deleted" records by default
      default_scope where(deleted_at: nil)
    end
    
    def mark_deleted?
      deleted_at?
    end
    
    # if there are couter caches needed to be decremented
    # implement decrement_counters method in model
    def mark_deleted
      mark_deleted? || ActiveRecord::Base.transaction do
        update_attribute :deleted_at, Time.now
        decrement_counters if respond_to? :decrement_counters
      end
    end
  end
end