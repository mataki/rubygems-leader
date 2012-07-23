namespace :user do
  desc "update ranking for all users"
  task refresh_ranking: :environment do
    User.refresh_rank
  end
end
