class User < ActiveRecord::Base
  include Gravtastic

  attr_accessible :name, :email, :github_username, :commit_count

  has_many :posts

  gravtastic secure: true, size: 512

  scope :contributions, where('users.commit_count IS NOT NULL').order('commit_count DESC')
  scope :github, where('users.github_username IS NOT NULL')
end
