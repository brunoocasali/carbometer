class OptimizeImports < ActiveRecord::Migration
  def change
    execute "delete from statistics"
    add_index :statistics, [:post_id, :source, :start_date, :end_date], name: 'unique_statistic', unique: true
  end
end
