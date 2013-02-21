require 'spec_helper'

describe Statistic do
  describe '::top_sources' do
    context 'posts exist with views from multiple sources' do
      before do
        @recent_post = FactoryGirl.create :post, published_at: Date.today
        FactoryGirl.create :statistic, post: @recent_post, visit_count: 15, start_date: Date.today - 1.day, source: 'theonion.com'
        FactoryGirl.create :statistic, post: @recent_post, visit_count: 5, start_date: Date.today - 2.day, source: 'comedycentral.com'
        FactoryGirl.create :statistic, post: @recent_post, visit_count: 10, start_date: Date.today - (Statistic::DEFAULT_DAY_RANGE - 1).days, source: 't.co'

        @out_of_range_post = FactoryGirl.create :post, published_at: Date.today - (Statistic::DEFAULT_DAY_RANGE + 100).days
        FactoryGirl.create :statistic, post: @out_of_range_post, visit_count: 1000, start_date: Date.today - (Statistic::DEFAULT_DAY_RANGE + 100).days, source: 'wikileaks.org'

        @top_sources = Statistic.top_sources(8)
      end

      it 'returns sources from within the date range' do
        expect(@top_sources.to_a).to have(3).sources
      end

      it 'returns sources ordered by visits DESC' do
        expect(@top_sources.first.visit_count).to eql(15)
      end

      it 'does not include sources outside of the default range' do
        expect(@top_sources.map(&:visit_count).sum).to eql(30)
      end
    end
  end
end
