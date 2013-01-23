require 'spec_helper'

describe Provider::PostFeed do

  describe '::find_all' do
    before do
      stub_requests_for(:wordpress)
      @feed = Provider::PostFeed.find_all
    end

    it 'returns a feed with all its posts' do
      expect(@feed.length).to equal(2)
    end
  end

end
