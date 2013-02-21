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
