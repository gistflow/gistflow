namespace :fixes do
  task create_wikis_for_tags: :environment do
    Tag.all.each &:create_wiki
  end
end
