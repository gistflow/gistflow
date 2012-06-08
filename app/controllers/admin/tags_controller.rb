class Admin::TagsController < ApplicationController
  def index
    @tags = Tag.includes(:entity).order(:name)
  end
  
  def edit
    @tag = find_tag(params[:id])
  end
  
  def entity
    @tag = find_tag(params[:tag_id])
    @entity = Tag.find(params[:tag][:entity_id])
    @tag.set_entity @entity
    redirect_to admin_tags_path
  end
  
protected
  
  def find_tag(id)
    Tag.find_by_name id
  end
end
