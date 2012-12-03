require 'spec_helper'

feature 'View a list of posts that are popular' do
  background 'User visits the Dashboard page' do
    @title = 'Popular Post'
    @author = FactoryGirl.create :user
    @posts = FactoryGirl.create_list :post, 8, :statistics, title: @title, author: @author
    visit '/dashboard'
    @script = page.find('body').find('script')
  end

  scenario 'JSON for recently visited posts in the script' do
    expect(@script).to have_content(@title)
  end

  scenario 'JSON for the author and published date of posts is in the script' do
    expect(@script).to have_content(@author.name)
    expect(@script).to have_content(Time.now.strftime('%B'))
    expect(@script).to have_content(Time.now.strftime('%Y'))
  end
end
