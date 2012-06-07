class TagsController < ApplicationController
  def show
    if @tag = Tag.find_by_name(params[:id])
      redirect_to @tag.entity if @tag.alias?
      
      @posts = Post.tagged_with(@tag.name).page(params[:page])
      @subscription = current_user.subscriptions
        .find_or_initialize_by_tag_id(@tag.id) if user_signed_in?
    else
      render 'search/nothing'
    end
  end
end