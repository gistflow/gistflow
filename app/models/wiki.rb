class Wiki < ActiveRecord::Base
  belongs_to :user
  belongs_to :tag
  
  validates :user, :content, :tag, presence: true
  
  attr_accessible :content
  
  # Creates a new version of wiki or return false
  def improve(content, user)
    new_wiki = tag.wikis.build do |wiki|
      wiki.content = content
      wiki.user    = user
    end
    new_wiki.save ? new_wiki : false
  end
end
