class PostsController < ApplicationController
  respond_to :json

  def index
    @posts = Post.in_default_date_range
    respond_with @posts
  end

  def sources
    respond_with Statistic.top_sources params[:limit] || 8
  end
end
