class AddWordpressIdToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :wordpress_id, :integer
  end
end
