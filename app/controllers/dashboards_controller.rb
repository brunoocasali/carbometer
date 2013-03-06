class DashboardsController < ApplicationController
  def show
    default_posts = Post.popular
    @posts = Jbuilder.encode do |json|
      json.array!(default_posts) do |post|
        json.id post.id
        json.title post.title
        json.path post.path
        json.published_at post.published_at.strftime("%B %d, %Y") unless post.published_at.nil?
        json.author_name post.author_name
        json.user_id post.user_id
        json.visit_sum post.visit_sum
        json.comment_count post.comment_count
      end
    end
  end
end
