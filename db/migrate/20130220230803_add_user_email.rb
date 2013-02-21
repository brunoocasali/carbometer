class AddUserEmail < ActiveRecord::Migration
  def change
    add_column :users, :email, :string

    User.all.each do |user|
      firstname = user.name.split(' ').first.downcase
      user.email = "#{firstname}@carbonfive.com"
      user.save!
    end
  end
end
