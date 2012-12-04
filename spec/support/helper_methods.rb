def auth(user = FactoryGirl.create(:user))
  visit root_path

  OmniAuth.config.mock_auth[:github] = {
    "provider" => "github",
    "uid"      => user.account_github.github_id,
    "info"     => {
      "nickname" => user.username,
      "email"    => user.profile.email,
      "name"     => user.name,
      "urls"     => { 
        "Blog"   => user.profile.home_page
      }
    },
    "credentials" => {
      "token" => user.account_github.token
    },
    "extra" => {
      "raw_info" => {
        "company" => user.profile.company,
        "gravatar_id" => user.gravatar_id
      }
    }
  }
  
  click_link 'Login'
end

def reload_current_page
  visit(current_path)
end
