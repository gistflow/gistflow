class Account::TwitterController < ApplicationController
  before_filter :authenticate!
  
  def create
    Account::Twitter.create_by_omniauth(omniauth) do |account|
      account.user = current_user
    end
    redirect_to root_path
  end
  
protected
  
  def omniauth
    request.env['omniauth.auth']
  end
end
