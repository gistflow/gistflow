module UsersHelper
  def contacts user
    profile = user.profile
    
    contacts = ""
    contacts << dt(user.name)
    contacts << dt(a "http://github.com/#{user.username}", target: '_blank')
    contacts << dt(a profile.home_page) unless profile.home_page.blank?
    contacts << dt(profile.company) unless profile.company.blank?
    contacts << dt(
      a "mailto:#{profile.email}", 
      { target: '_blank' }, 
      profile.email
    ) unless profile.email.blank?
    
    content_tag(:dl, contacts.html_safe)
  end
  
  protected
  def dt content, options = {}
    content_tag(
      :dt,
      content_tag(:dd, content),
      options
    )
  end
  
  def a href, options = {}, text = nil
    options[:href] = href
    content_tag(
      :a,
      text || href,
      options
    ).html_safe
  end
end