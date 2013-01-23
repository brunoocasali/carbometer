require 'spec_helper'

describe Provider::PostFeed do

  describe '::find_all' do
    before do
      stub_requests_for(:wordpress)
      @feed = Provider::PostFeed.find_all
    end

    it 'returns a feed with all its posts' do
      expect(@feed.entries.length).to equal(2)
    end
  end

  describe '::page' do
    context 'by default' do
      before do
        stub_requests_for(:wordpress)
        @feed = Provider::PostFeed.page
      end

     it 'returns the 2 latest posts' do
        expect(@feed.length).to equal(2)
      end
    end
  end

  describe '::post' do
    before do
      stub_requests_for(:wordpress)
      @post = Provider::PostFeed.post('12345')
    end

    it 'returns current info for a post' do
      expect(@post['author']['name']) == 'Jon Cooper'
      expect(@post['comment_count']) == 2
    end
  end
end
