FactoryGirl.define do
  factory :post do
    title 'title'
    path  '/valid-post'
    published_at {Time.now}
    association :author, factory: :user
    wordpress_id  54321
    comment_count  0

    trait :statistics do
      statistics {
        FactoryGirl.create_list :statistic, 10
      }
    end

    trait :with_statistic do
      statistics {
        [
          FactoryGirl.create(:statistic)
        ]
      }
    end

    trait :popular do
      title 'Popular Post'
      statistics {
        [
          FactoryGirl.create(:statistic, visit_count: 1000000)
        ]
      }
    end
  end
end
