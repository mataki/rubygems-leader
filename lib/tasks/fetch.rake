namespace :fetch do
  desc "Fetch all profile with numeric"
  task all: :environment do
    num = ENV["num"] ? ENV['num'].to_i : 100
    Fetcher.crawl_from_max(num)
  end

  desc "Update data since 3 days"
  task update: :environment do
    Fetcher.update_data
  end
end

namespace :refresh do
  desc "Refresh ranking"
  task rank: :environment do
    Fetcher.refresh_rank
  end
end
