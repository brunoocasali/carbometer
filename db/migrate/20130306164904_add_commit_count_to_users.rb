class AddCommitCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :commit_count, :integer
  end
end
