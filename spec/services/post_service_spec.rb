require 'spec_helper'

describe PostService do

  describe '::reset_posts' do
    before do
      PostService.stub!(:sleep)
      stub_requests_for(:google)
      @existing_post = FactoryGirl.create :post, :statistics
      PostService.reset_posts
      # This title was pulled from the json fixture for webmock
      @new_post = Post.find_by_title('Using Open Source Static Libraries in Xcode 4')
    end

    it 'deletes existing posts' do
      expect {Post.find(@existing_post.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'creates new posts from analytics data' do
      expect(@new_post).to_not be_nil
    end
  end

  describe '::update_posts' do
    before do
      PostService.stub!(:sleep)
      stub_requests_for(:google)
      @existing_post = FactoryGirl.create :post
      @existing_statistic = FactoryGirl.create :statistic, :post => @existing_post, :start_date => Date.today - 5.days, :end_date => Date.today - 5.days

      Provider::PostAnalytics.should_receive(:find_all_by_date_range).exactly(4).times.and_return([])
      PostService.update_posts
    end

    it 'does not delete existing posts' do
      Post.find_by_id(@existing_post.id).should_not be_nil
    end
  end

  describe '::import_post_statistic' do
    context 'given a new post' do
      before do
        @post_path = '/post/1'
        expect(Post.where(path: @post_path)).to be_empty

        PostService.import_post_statistic 'title',
                                          @post_path,
                                          Date.today,
                                          Date.today,
                                          'google.com',
                                          1
        @imported_posts = Post.where(path: @post_path)
      end

      it 'creates the post' do
        expect(@imported_posts).to have(1).post
      end

      it 'creates a statistic for the post' do
        expect(@imported_posts.first.statistics).to have(1).statistic
      end
    end

    context 'given an existing post' do
      before do
        @post = FactoryGirl.create :post
      end

      context 'given a statistic from a source exists' do
        before do
          statistic = FactoryGirl.create :statistic, post: @post
          @start_date = statistic.start_date
          @end_date = statistic.end_date
          @source = statistic.source
        end

        context 'when importing from existing date range' do
          before do
            PostService.import_post_statistic @post.title,
                                              @post.path,
                                              @start_date,
                                              @end_date,
                                              @source,
                                              2
            @post.reload
          end

          it 'does not re-create the statistic' do
            expect(@post.statistics).to have(1).statistic
          end

          it 'updates the existing statistic' do
            expect(@post.statistics.first.visit_count).to eq(2)
          end

          context 'when importing from a new source' do
            before do
              PostService.import_post_statistic @post.title,
                                                @post.path,
                                                @start_date,
                                                @end_date,
                                                'newsource.com',
                                                2
            end

            it 'creates a statistic for the post' do
              expect(@post.statistics).to have(2).statistics
            end
          end
        end

        context 'when importing from new date range' do
          before do
            PostService.import_post_statistic @post.title,
                                              @post.path,
                                              Date.new(1970,01,01),
                                              Date.new(1970,01,01),
                                              @source,
                                              2
            @post.reload
          end

          it 'creates a statistic for the post' do
            expect(@post.statistics).to have(2).statistics
          end
        end
      end
    end
  end

  describe '::import_post_statistics' do
    before do
      source_one = Provider::PostAnalytics.new({
        page_title: 'title',
        page_path: 'path',
        visits: 1,
        source: 'one',
        start_date: Date.today,
        end_date: Date.today
      })
      source_two = source_one.clone
      source_two.source = 'two'
      source_two.start_date = Date.tomorrow
      source_two.end_date = Date.tomorrow
      post_analytics = [source_one, source_two]


      @imported_statistics_count = PostService.import_post_statistics post_analytics
      @imported_posts = Post.find_all_by_title 'title'
    end

    it 'associates multiple sources to single post' do
      expect(@imported_posts.length).to equal(1)
      expect(@imported_posts.first.statistics.length).to equal(2)
    end

    it 'returns the number of statistics imported' do
      expect(@imported_statistics_count).to equal(2)
    end
  end

  describe '::import_posts' do
    before do
      @title = 'Title'
      @author = FactoryGirl.build :user
      @path = '/1/2/3/'
      @published_at = Time.now

      feed_entry = double(
        title: @title,
        url: "http://blog.carbonfive.com#{@path}",
        published: @published_at,
        author: @author.name
      )
      feed = double(
        entries: [feed_entry]
      )
      Provider::PostFeed.stub(:find_all).and_return(feed)
    end

    context 'given existing posts' do
      before do
        @existing_post = FactoryGirl.create :post,
          title: @title,
          path: @path
        @author.save
        @imported_post = PostService.import_posts.first
      end

      it 'does NOT create a duplicate post' do
        expect(Post.find_all_by_path(@path).length).to eq(1)
      end

      it 'does NOT create a duplicate user' do
        expect(User.find_all_by_name(@author.name).length).to eq(1)
      end

      it 'associates an author with existing post' do
        expect(@imported_post.author.name).to eq(@author.name)
      end

      it 'truncates the post URL as path' do
        expect(@imported_post.path).to eq(@path)
      end

      it 'sets the publishing date for existing post' do
        expect(@imported_post.published_at.to_s).to eq(@published_at.to_s)
      end
    end

    context 'NOT given existing posts' do
      before do
        @imported_posts = PostService.import_posts
      end

      it 'imports posts from an RSS feed' do
        expect(@imported_posts.length).to eq(1)
        @imported_posts.each do |post|
          expect(post.author.name).to eq(@author.name)
          expect(post.title).to eq(@title)
          expect(post.path).to eq(@path)
          expect(post.published_at).to eq(@published_at)
        end
      end
    end
  end

end
