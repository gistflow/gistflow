class UsersController < ApplicationController
  def create
    account = Account::Github.find_or_create_by_omniauth(omniauth)
    self.current_user = account.user
    redirect_to root_path
  end

protected

  def omniauth
    request.env['omniauth.auth']
  end
end