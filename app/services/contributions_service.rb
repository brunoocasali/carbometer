class ContributionsService
  def self.update_counts
    User.github.each do |user|
      commit_count = Provider::Contributions.fetch(user.github_username)
      user.update_attribute :commit_count, commit_count
    end
  end
end
