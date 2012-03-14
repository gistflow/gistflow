unless Rails.env.test?
  $indextank = IndexTank::Client.new(ENV['SEARCHIFY_API_URL'])
end
