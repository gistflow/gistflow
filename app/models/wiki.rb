class Wiki < ActiveRecord::Base
  include Models::Cuttable
  include Models::Taggable
  
  belongs_to :user
  belongs_to :tag
  
  validates :user, :content, :tag, presence: true
  
  attr_accessible :content
  
  def title
    "#{tag.name}'s wiki".capitalize
  end
  
  # Creates a new version of wiki or return false
  def improve(attributes, user)
    new_wiki = tag.wikis.build(attributes) do |wiki|
      wiki.user = user
    end
    new_wiki.save ? new_wiki : false
  end
  
  def path
    "/tags/#{tag}/wiki"
  end
end
