class GA
  extend Garb::Model

  metrics :pageviews
  dimensions :page_path

  attr_reader :profile

  def initialize
    Garb::Session.login(
      Configuration.google_analytics.login,
      Configuration.google_analytics.password
    )

    @profile = Garb::Management::Profile.all.detect do |profile| 
      profile.web_property_id == Configuration.google_analytics.web_property_id
    end
  end

  def page_views post
    GA.results(
      profile,
      :filters => { :page_path.eql => post.path },
      :start_date => 5.years.ago.to_date,
      :end_date => Date.today
    ).to_a.first.try(:pageviews)
  end
end