namespace :data do
  desc "remove users with 0 total downloads"
  task cleanup: :environment do
    RAILS_ENV ||= :development
    config = ActiveRecord::Base.configurations
    ActiveRecord::Base.establish_connection(config[RAILS_ENV])
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("delete from users where total_downloads = 0")
    end
  end
end
