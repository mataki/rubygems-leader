namespace :user do
  desc "update ranking for all users"
  task refresh_ranking_and_create_history: :environment do
    User.refresh_rank
    User.create_rank_histories
  end
end
