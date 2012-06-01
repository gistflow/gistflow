require 'spec_helper'

describe Account::Github do
  describe '#find_or_create_by_omniauth' do
    let(:auth) do
      { "provider" => "github",
        "uid"      => 348907,
        "info"     => {
          "nickname" => "releu",
          "email"    => "releu@me.com",
          "name"     => "Jan Bernacki",
          "urls"     => { 
            "GitHub" => "https://github.com/releu",
            "Blog"   => "http://gistflow.com"
          }
        },
        "credentials" => {
          "token" => "foobar",
          "expires" => false
        },
        "extra"=> { 
          "raw_info" => {
            "collaborators" => 1,
            "public_gists" => 6,
            "type" => "User",
            "blog" => "",
            "plan" => { 
              "collaborators" => 1,
              "space" => 614400,
              "private_repos" => 5,
              "name" => "micro"
            },
            "location" => "Moscow",
            "private_gists" => 6,
            "followers"     => 4,
            "company"       => "KupiKupon",
            "disk_usage"    => 1208,
            "html_url"      => "https://github.com/releu",
            "created_at"    => "2010-07-30T04:18:24Z",
            "email"         => "releu@me.com",
            "hireable"      => false,
            "gravatar_id"   => "757fb0d5ec7560b6f25f5bd98eadc020",
            "bio"           => nil,
            "public_repos"  => 5,
            "total_private_repos" => 3,
            "following"     => 2,
            "name"          => "Jan Bernacki",
            "login"         => "releu",
            "url"           => "https://api.github.com/users/releu",
            "id"            => 348907,
            "owned_private_repos" => 3,
            "avatar_url"    => "https://secure.gravatar.com/avatar/757fb0d5ec7560b6f25f5bd98eadc020?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png"
          }
        }
      }
    end
    
    it { Account::Github.should respond_to(:find_or_create_by_omniauth) }
    
    context 'account persisted' do
      let(:account) { FactoryGirl.create(:account_github) }
      before do
        auth['uid'] = account.github_id
      end
      
      it 'should find account' do
        Account::Github.find_or_create_by_omniauth(auth).should eq(account)
      end
    end
    
    context 'account not found' do
      let(:account) { Account::Github.find_or_create_by_omniauth(auth) }
      let(:user) { account.user }
      
      it { account.should be_persisted }
      it { user.profile.should be_persisted }
      it { user.settings.should be_persisted }
      it { account.token.should == 'foobar' }
      it { account.github_id.should == 348907 }
      it { user.should be_persisted }
      it { user.username.should == 'releu' }      
      it { user.name.should == 'Jan Bernacki' }
      it { user.gravatar_id.should == '757fb0d5ec7560b6f25f5bd98eadc020' }
      
      it { user.profile.email.should == 'releu@me.com' }
      it { user.profile.company.should == 'KupiKupon' }
      it { user.profile.home_page.should == 'http://gistflow.com' }
    end
    
    context 'minimum data' do
      let(:min_auth) do
        min_auth = auth.dup
        min_auth['info'] = {
          "nickname" => "releu",
          "email"    => nil,
          "name"     => nil,
          "urls"     => { 
            "GitHub" => nil,
            "Blog"   => nil
          }
        }
        min_auth['extra']['raw_info'] = {
          "gravatar_id" => '757fb0d5ec7560b6f25f5bd98eadc020'
        }
        min_auth
      end
      let(:account) { Account::Github.find_or_create_by_omniauth(min_auth) }
      let(:user) { account.user }
      
      it { account.should be_persisted }
      it { user.profile.should be_persisted }
      it { user.settings.should be_persisted }
      it { account.token.should == 'foobar' }
      it { account.github_id.should == 348907 }
      it { user.should be_persisted }
      it { user.username.should == 'releu' }
      it { user.name.should == 'releu' }
      it { user.gravatar_id.should == '757fb0d5ec7560b6f25f5bd98eadc020' }
      it { user.profile.home_page.should be_nil }
      it { user.profile.email.should be_nil }
      it { user.profile.company.should be_nil }
    end
  end
end
