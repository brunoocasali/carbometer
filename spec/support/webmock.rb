require 'webmock/rspec'

def stub_requests_for(requests_for)
  self.send("stub_requests_for_#{requests_for}")
end

def stub_requests_for_google
  Google::APIClient::PKCS12.stub(:load_key) do |keyfile, passphrase|
    OpenSSL::PKey::RSA.new 1024
  end

  stub_request(:post, "https://accounts.google.com/o/oauth2/token").
    to_return(status: 200,
              body: fixture_for('oauth.json'))

  stub_request(:get, "https://www.googleapis.com/discovery/v1/apis/analytics/v3/rest").
    to_return(status: 200,
              body: fixture_for('discovery.json'))

  stub_request(:get, /www\.googleapis\.com\/analytics\/v3\/data\/ga/).
    to_return(status: 200,
              body: fixture_for('google_analytics.json'),
              headers: {'Content-Type' => 'application/json'})

end

def stub_requests_for_wordpress
  stub_request(:get, 'https://public-api.wordpress.com/rest/v1/sites/blog.carbonfive.com/posts/?type=post&page=1').
    to_return(status: 200,
              body: fixture_for('wordpress_posts.json'),
              headers: {'Content-Type' => 'application/json'})

  stub_request(:get, 'https://public-api.wordpress.com/rest/v1/sites/blog.carbonfive.com/posts/?type=post&page=2').
    to_return(status: 200,
              body: "{\"found\":0,\"posts\":[]}",
              headers: {'Content-Type' => 'application/json'})

  stub_request(:get, /^https:\/\/public\-api\.wordpress\.com\/rest\/v1\/sites\/blog\.carbonfive\.com\/posts\/[0-9]+/).
    to_return(status: 200,
              body: fixture_for('wordpress_single_post.json'),
              headers: {'Content-Type' => 'application/json'})
end

def stub_requests_for_twitter
  stub_request(:get, /^http:\/\/urls\.api\.twitter\.com\/1\/urls\/count\.json\?callback=&url=http\:\/\/blog\.carbonfive\.com\//).
    to_return(status: 200,
              body: fixture_for('twitter_tweet_count.json'),
              headers: {'Content-Type' => 'application/json'})
end

def stub_requests_for_github
  client_id, client_secret = 'foo', 'bar'
  auth_params = "?client_id=#{client_id}&client_secret=#{client_secret}"

  Carbometer::Application.config.stub(:github_client_id).and_return client_id
  Carbometer::Application.config.stub(:github_client_secret).and_return client_secret

  stub_request(:get, "https://api.github.com/users/linusstallman/repos#{auth_params}")
    .to_return(
      status: 200,
      body: fixture_for('github/repos.json'),
      headers: {'Content-Type' => 'application/json'}
    )

  %w(aasm active_merchant bootstrap).each do |repo|
    stub_request(:get, "https://api.github.com/repos/linusstallman/#{repo}/commits#{auth_params}")
      .to_return(
        status: 200,
        body: fixture_for("github/#{repo}_commits.json"),
        headers: {'Content-Type' => 'application/json'}
      )
  end
end
