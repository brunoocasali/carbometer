json.array!(@users) do |user|
  json.login user.name
  json.avatar_url user.gravatar_url
  json.commit_count user.commit_count
end
