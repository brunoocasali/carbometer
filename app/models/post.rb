class Post < ActiveRecord::Base
  DEFAULT_DAY_RANGE = 30

  attr_accessible :title,
                  :path,
                  :published_at
  has_many        :statistics, dependent: :destroy
  belongs_to      :author, foreign_key: :user_id, class_name: 'User'

  def cumulative_visit_count
    statistics.sum(:visit_count)
  end

  def self.popular
    Post.joins(:statistics)
        .joins('LEFT OUTER JOIN users ON users.id = posts.user_id')
        .where('statistics.start_date >= ?', Date.today - DEFAULT_DAY_RANGE.days)
        .select('posts.*, SUM(statistics.visit_count) AS visit_sum, users.name AS author_name, users.email AS author_email')
        .group('posts.id, posts.title, posts.path, posts.user_id, posts.published_at, users.name, users.email')
        .order('visit_sum DESC')
        .limit(8)
  end
end
