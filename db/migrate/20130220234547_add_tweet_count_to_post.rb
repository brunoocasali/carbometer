class AddTweetCountToPost < ActiveRecord::Migration
  def change
    add_column :posts, :tweet_count, :integer
  end
end
