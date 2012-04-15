class Account::TwitterController < ApplicationController
  before_filter :authenticate!
  
  def create
    current_user.account_twitters.create!(omniauth)
    redirect_to root_path
  end
  
protected
  
  def omniauth
    request.env['omniauth.auth']
  end
end
