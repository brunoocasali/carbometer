class User < ActiveRecord::Base
  include Gravtastic

  attr_accessible :name,
                  :email

  has_many        :posts

  gravtastic secure: true,
             size: 512
end
