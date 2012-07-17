desc "Fetch numeric"
task fetch: :environment do
  num = ENV["num"].to_i || 100
  User.crowl_from_max(num)
end
