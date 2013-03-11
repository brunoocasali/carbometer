require 'spec_helper'

describe ContributionsService do
  describe '.update_counts' do
    context 'given there are Github users' do
      let(:users) do
        create_list :github_user, 3, commit_count: 0
      end

      let(:expected_user_commits) do
        users.inject({}) do |commit_counts, user|
          commit_count = rand(100)
          commit_counts.merge({ user.github_username => commit_count })
        end
      end

      before do
        expected_user_commits.each do |github_username, commit_count|
          Provider::Contributions
            .should_receive(:fetch)
            .with(github_username)
            .and_return commit_count
        end

        ContributionsService.update_counts
      end

      it 'updates user commit counts' do
        User.github.each do |user|
          commit_count = expected_user_commits[user.github_username]
          expect(user.commit_count).to eq(commit_count)
        end
      end
    end
  end
end
