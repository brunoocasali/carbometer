FactoryGirl.define do
  factory :user do
    sequence(:name) {|n| "Developer #{n}" }
    sequence(:email) {|n| "dev#{n}@carbonfive.com" }

    trait :with_github_account do
      sequence(:github_username) {|n| "github_handle_#{n}" }
      commit_count 0
    end

    factory :github_user, traits: [:with_github_account]
  end
end
