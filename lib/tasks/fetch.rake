namespace :fetch do
  desc "Fetch all profile with numeric"
  task all: :environment do
    num = ENV["num"].to_i || 100
    User.crowl_from_max(num)
  end

  desc "Update data since 3 days"
  task update: :environment do
    User.update_data
  end
end

namespace :reflesh do
  desc "Reflesh ranking"
  task rank: :environment do
    User.refresh_rank
  end
end
