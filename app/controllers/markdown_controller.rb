class MarkdownController < ApplicationController
  def create
    html = Markdown.markdown(params[:raw])
    render json: { html: html }
  end
end
