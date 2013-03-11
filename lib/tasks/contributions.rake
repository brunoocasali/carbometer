namespace :contributions do
  desc 'Update recent commits count'
  task update: :environment do
    p 'Updating contributions...'
    time_elapsed = Benchmark.realtime do
      ContributionsService.update_counts
    end
    p "Finished in #{time_elapsed} seconds"
  end
end
