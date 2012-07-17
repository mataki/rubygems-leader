desc "Fetch numeric"
task fetch: :environment do
  num = ENV["num"].to_i || 100
  User.crowl_from_max(num)
end

task update_data: :environment do
  User.update_data
end

task update_rank: :environment do
  User.refresh_rank
end
