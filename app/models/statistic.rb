class Statistic < ActiveRecord::Base
  DEFAULT_DAY_RANGE = 30

  attr_accessible :source,
                  :start_date,
                  :end_date,
                  :visit_count
  belongs_to      :post

  def self.top_sources(limit)
    self.where('statistics.start_date >= ?', Date.today - DEFAULT_DAY_RANGE.days)
    .select('statistics.source, sum(statistics.visit_count) as visit_count')
    .group('statistics.source')
    .order('visit_count DESC')
    .limit(limit)
  end

end
