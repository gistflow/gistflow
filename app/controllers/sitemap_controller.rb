class SitemapController < ApplicationController
  def show
    @tags = Tag.all
    @posts = Post.not_private.all
    @users = User.all
    respond_to do |format|
      format.xml
    end
  end
end