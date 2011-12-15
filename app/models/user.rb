class User < ActiveRecord::Base
  has_many :authentications
  
  def self.create_from_hash!(hash)
    create(:name => hash['user_info']['name'])
  end
end