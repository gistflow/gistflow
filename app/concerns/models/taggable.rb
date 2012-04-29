module Models
  module Taggable
    extend ActiveSupport::Concern
    
    included do
      has_many :taggings, as: :taggable
      has_many :tags, through: :taggings
    
      scope :tagged_with, (lambda do |names|
        joins(:tags).where(tags: { name: names }).uniq
      end)
      
      after_save :assign_tags, :subscribe_user
      
    end
    
    module InstanceMethods
    protected
      
      def assign_tags
        self.tags = Replaceable.new(content).tagnames.map do |name|
          Tag.where(name: name).first_or_create!
        end
      end

      def subscribe_user
        (tags - user.tags).each do |tag|
          user.subscriptions.create! do |subsctiption|
            subsctiption.tag = tag
          end rescue ActiveRecord::RecordNotUnique
        end
      end
    end
  end
end