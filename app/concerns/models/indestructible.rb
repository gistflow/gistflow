module Models
  # Added mark_delete methods and prevent destroying record
  module Indestructible
    extend ActiveSupport::Concern
    
    included do
      # prevent destroy action if it called by accident
      before_destroy { false }
    end
    
    def mark_deleted?
      deleted_at?
    end
    
    def mark_deleted
      mark_deleted? || update_attribute(:deleted_at, Time.now)
    end
  end
end