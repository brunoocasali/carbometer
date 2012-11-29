FactoryGirl.define do

  factory :statistic do
    source      'google.com'
    start_date  {Date.today - Post::DEFAULT_DAY_RANGE.days}
    end_date    {Date.today}
    visit_count {rand(1...100)}
  end

end
