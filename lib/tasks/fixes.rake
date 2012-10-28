namespace :fixes do
  task create_wikis_for_tags: :environment do
    Tag.all.each do |tag|
      tag.wikis.create! do |wiki|
        wiki.content = 'Nothing to display yet.'
        wiki.user = User.gistflow
      end
    end
  end
end
