class Provider::Contributions

  class << self
    def auth_params
      client_id     = Carbometer::Application.config.github_client_id
      client_secret = Carbometer::Application.config.github_client_secret

      "?client_id=#{client_id}&client_secret=#{client_secret}"
    end

    def fetch username
      response = HTTParty.get "https://api.github.com/users/#{username}/repos#{auth_params}"
      repos = JSON response.body

      commit_counts = repos.map do |repo|
        response = HTTParty.get "https://api.github.com/repos/#{username}/#{repo['name']}/commits#{auth_params}"
        commits = JSON response.body

        if commits.is_a?(Array)
          authors = commits.map do |commit|
            commit['author']
          end.compact

          repo_commit_count = authors.select do |author|
            author['login'] == username
          end.count

          repo_commit_count
        else
          0
        end
      end

      commit_counts.reduce(:+) || 0
    end
  end

end
