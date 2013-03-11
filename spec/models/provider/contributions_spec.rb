require 'spec_helper'

describe Provider::Contributions do
  describe '.fetch' do
    before do
      stub_requests_for(:github)
      @commit_count = Provider::Contributions.fetch('linusstallman')
    end

    it 'returns the number of recent commits' do
      expect(@commit_count).to eq(9)
    end
  end
end
