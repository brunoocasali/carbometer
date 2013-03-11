class PostService
  cattr_accessor :github_usernames

  class << self
    def reset_posts
      Post.destroy_all

      import_posts

      update_post_analytics
    end

    def update_posts
      import_posts

      update_post_comment_counts

      update_tweet_counts

      statistics_count = update_post_analytics

      statistics_count
    end

    def import_post_statistics(all_post_analytics)
      all_post_analytics.each do |post_analytics|
        title = post_analytics.page_title
        path =  post_analytics.page_path
        start_date = post_analytics.start_date
        end_date = post_analytics.end_date
        source = post_analytics.source
        visits = post_analytics.visits

        import_post_statistic title, path, start_date, end_date, source, visits
      end

      all_post_analytics.length
    end

    def import_post_statistic(title, path, start_date, end_date, source, visits)
      stat_attrs = {
        source: source,
        start_date: start_date,
        end_date: end_date,
        visit_count: visits
      }

      post = Post.find_by_title_and_path title, path
      if post
        existing_statistics = post.statistics.where(source: source,
                                                    start_date: start_date,
                                                    end_date: end_date)
        if existing_statistics.any?
          existing_statistics.update_all stat_attrs
        else
          post.statistics.create stat_attrs
        end
      end
    end

    def initialize_github_usernames
      self.github_usernames = YAML.load_file "#{Rails.root}/db/github_usernames.yml"
    end

    def import_posts
      initialize_github_usernames

      feed = Provider::PostFeed.find_all
      posts = []

      feed.each do |feed_entry|
        post = Post.find_or_initialize_by_wordpress_id(
          wordpress_id: feed_entry['ID']
        )
        posts << post
        author = import_author feed_entry['author']['name']
        post.title = feed_entry['title']
        path = URI.parse(feed_entry['URL']).path
        post.path = path
        post.published_at = feed_entry['date']
        post.wordpress_id = feed_entry['ID']
        post.comment_count = feed_entry['comment_count']
        post.author = author
        post.save
      end

      posts
    end

    def import_author(name)
      first_name = name.split(' ').first.downcase
      email = "#{first_name}@carbonfive.com"
      github_username = github_usernames[name]

      user = User.find_or_create_by_name({
        name: name,
        email: email,
        github_username: github_username
      })
    end

  end

  protected

  def self.update_post_comment_counts
    all_post_info = Provider::PostFeed.find_all

    Post.all.each do |post|
      if post.wordpress_id
        post_info = all_post_info.select { |post_update| post_update['ID'] == post.wordpress_id }
        post.comment_count = post_info.first['comment_count']
        post.save
      end
    end
  end

  def self.update_post_analytics
    count = 0

    last_run_date = Statistic.maximum(:end_date) || Date.today - 30.days
    ((last_run_date+1)..(Date.today-1)).each do |date|
      sleep 30
      post_analytics = Provider::PostAnalytics.find_all_by_date_range date, date
      count += import_post_statistics post_analytics
    end

    count
  end

  def self.update_tweet_counts
    Post.all.each do |post|
      tweet_count = Provider::PostTweets.get_tweets_for_path(post.path)
      post.update_attribute(:tweet_count, tweet_count)
    end
  end
end
