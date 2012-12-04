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
    
  protected
      
    def assign_tags
      html = Markdown.markdown(content)
      tags = Replaceable.new(html).tagnames.map do |name|
        tag = Tag.where(name: name).first_or_create!
        tag.alias? ? tag.entity : tag
      end.uniq
      self.tags = tags
    end

    def subscribe_user
      (tags - user.tags(true)).each do |tag|
        user.subscriptions.create! do |subsctiption|
          subsctiption.tag = tag
        end rescue ActiveRecord::RecordNotUnique
      end
    end
  end
end