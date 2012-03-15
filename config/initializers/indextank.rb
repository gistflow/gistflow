if ENV['SEARCHIFY_API_URL']
  $indextank = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
end
