namespace :fetch do
  desc "Fetch numeric"
  task all: :environment do
    num = ENV["num"].to_i || 100
    User.crowl_from_max(num)
  end

  task update: :environment do
    User.update_data
  end
end

namespace :reflash do
  task rank: :environment do
    User.refresh_rank
  end
end
