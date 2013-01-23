FactoryGirl.define do
  factory :statistic do
    source      'google.com'
    sequence(:start_date) do |n|
      Date.today - Post::DEFAULT_DAY_RANGE.days + n
    end
    end_date    { start_date + 1 }
    visit_count { rand(1...100) }
  end
end
