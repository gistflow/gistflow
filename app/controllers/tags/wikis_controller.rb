class Tags::WikisController < ApplicationController
  cache_sweeper :user_sweeper
  prepend_before_filter :authenticate!, only: [:edit, :update]
  
  def history
    @tag = find_tag(params[:tag_id])
    @wikis = @tag.wikis.includes(:user).order('id desc')
    @contributors = @wikis.map(&:user).uniq
  end
  
  def show
    @wiki = find_wiki(params[:tag_id])
  end
  
  def edit
    @wiki = find_wiki(params[:tag_id])
  end
  
  def update
    @wiki = find_wiki(params[:tag_id])
    if @wiki.improve(params[:wiki], current_user)
      redirect_to tag_wiki_path(@wiki.tag)
    else
      render :edit
    end
  end
  
protected
  
  def find_wiki(tag_name)
    find_tag(tag_name).wiki
  end
  
  def find_tag(tag_name)
    Tag.find_by_name(tag_name)
  end
end
