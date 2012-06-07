def auth
  visit root_path
  click_link 'Login'
end

def reload_current_page
  visit(current_path)
end