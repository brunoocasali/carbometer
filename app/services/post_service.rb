class PostService
  def self.reset_posts
    Post.destroy_all
    self.update_posts
  end

  def self.update_posts
    count = 0

    last_run_date = Statistic.maximum(:end_date) || Date.today - 30.days
    ((last_run_date+1)..(Date.today-1)).each do |date|
      sleep 30
      post_analytics = Provider::PostAnalytics.find_all_by_date_range date, date
      count += import_post_statistics post_analytics
    end

    count
  end

  def self.import_post_statistics(all_post_analytics)
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

  def self.import_post_statistic(title, path, start_date, end_date, source, visits)
    post = Post.find_or_create_by_title_and_path title, path
    existing_statistics = post.statistics.where(source: source,
                                                start_date: start_date,
                                                end_date: end_date)
    stat_attrs = {
      source: source,
      start_date: start_date,
      end_date: end_date,
      visit_count: visits
    }

    if existing_statistics.any?
      existing_statistics.update_all stat_attrs
    else
      post.statistics.create stat_attrs
    end
  end

  def self.import_posts
    feed = Provider::PostFeed.find_all
    posts = []

    feed.each do |feed_entry|
      post = Post.find_or_create_by_title_and_path(
        title: feed_entry['title'],
        path: URI(feed_entry['URL']).path
      )
      posts << post
      author = import_author feed_entry['author']['name']
      post.published_at = feed_entry['published']
      post.author = author
      post.save
    end

    posts
  end

  def self.import_author(name)
    first_name = name.split(' ').first.downcase
    email = "#{first_name}@carbonfive.com"
    User.find_or_create_by_name({
      name: name,
      email: email
    })
  end
end
