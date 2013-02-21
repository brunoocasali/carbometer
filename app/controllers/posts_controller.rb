class PostsController < ApplicationController
  respond_to :json

  def index
    @posts = Post.popular
    respond_with @posts
  end

  def popular
    @posts = Post.popular
    respond_with @posts
  end

  def sources
    respond_with Statistic.top_sources params[:limit] || 8
  end
end
