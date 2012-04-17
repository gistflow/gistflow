class Admin::UsersController < ApplicationController
  def index
    @users = User.page(params[:page])
  end
end