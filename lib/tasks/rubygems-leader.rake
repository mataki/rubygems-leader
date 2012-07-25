namespace :data do
  desc "remove users with 0 total downloads"
  task cleanup: :environment do
    User.delete_all(total_downloads: 0)
  end
end
