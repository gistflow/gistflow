class Account::TwitterController < ApplicationController
  def create
    Rails.logger.info request.env['omniauth.auth'].inspect
  end
end
