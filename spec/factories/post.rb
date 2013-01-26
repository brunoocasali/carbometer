FactoryGirl.define do
  factory :post do
    title 'title'
    path  '/a/b/c/'
    published_at {Time.now}

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
