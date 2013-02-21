json.array!(posts) do |post|
  json.id post.id
  json.title post.title
  json.path post.path
  json.published_at post.published_at.strftime("%B %d, %Y")
  json.author_name post.author_name
  json.author_image post.author.gravatar_url
  json.user_id post.user_id
  json.visit_sum post.visit_sum
end
