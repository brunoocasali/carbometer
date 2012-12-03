class PostsController < ApplicationController
  respond_to :json

  def index
    @posts = Post.in_default_date_range
    respond_with @posts
  end
end
