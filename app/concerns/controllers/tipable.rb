module Controllers
  module Tipable
    extend ActiveSupport::Concern
    
    included do
      before_filter :assign_tip
    end
    
    def assign_tip
      flash[:info] ||= Tip.random
    end
  end
end
