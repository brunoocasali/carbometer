class User < ActiveRecord::Base
  include Gravtastic

  attr_accessible :name,
                  :email

  has_many        :posts

  is_gravtastic
end
