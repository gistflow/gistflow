namespace :fixes do
  task create_wikis_for_tags: :environment do
    Tag.all.each do |tag|
      tag.wikis.create! do |wiki|
        wiki.content = 'Nothing to display jet.'
        wiki.user = User.find_by_username('releu')
      end
    end
  end
end
