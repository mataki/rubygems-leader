desc "Fetch numeric"
task fetch: :environment do
  User.crowl_from_max(100)
end
