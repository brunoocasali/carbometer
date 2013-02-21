require 'spec_helper'

describe Provider::PostTweets do
  describe '::get_tweets_for_path' do
    before do
      stub_requests_for(:twitter)
      path = '/valid-post'
      @tweets = Provider::PostTweets.get_tweets_for_path(path)
    end

    it 'returns current tweet count for a post' do
      expect @tweets == 21
    end
  end
end
