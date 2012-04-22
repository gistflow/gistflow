class SitemapController < ApplicationController
  def show
    @tags = Tag.all
    @posts = Post.all
    @users = User.all
    respond_to do |format|
      format.xml
    end
  end
end