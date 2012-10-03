class MarkdownController < ApplicationController
  def create
    html = Markdown.markdown(params[:raw])
    render text: html
  end
end
