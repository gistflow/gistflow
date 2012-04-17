class Admin::UsersController < ApplicationController
  def index
    p = params[:page].to_i
    @users = User.page(p)
    @count = User.count
    @offset = p > 1 ? (p - 1) * 25 : 0
  end
end