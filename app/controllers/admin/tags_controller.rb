class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.includes(:entity).order(:name)
  end
  
  def edit
    @tag = find_tag(params[:id])
  end
  
  def update
    @tag = find_tag(params[:id])
    if @tag.update_attributes(params[:tag], as: :admin)
      redirect_to admin_tags_path
    else
      render :edit
    end
  end
  
protected
  
  def find_tag(id)
    Tag.find_by_name id
  end
end
