class User < ActiveRecord::Base
  attr_accessible :email, :handle, :profile_id, :total_downloads

  validates :handle, presence: true
  validates :email, presence: true
  validates :profile_id, presence: true

  def self.fetch_and_save!(profile_id)
    user = User.find_or_initialize_by_profile_id(profile_id)
    user.attributes = Fetcher.get(profile_id)
    user.save!
  end

  def self.crowl_numeric(start_num, renge)
    logger.info "[FETCH START] from #{start_num}"
    end_num = start_num+renge
    failed_count = 0
    (start_num...end_num).each do |i|
      begin
        fetch_and_save!(i)
      rescue => e
        logger.error "[Fetch Error] profile_id: #{i}"
        logger.error e
        failed_count += 1
        if failed_count > 10
          logger.error "[Fetch Error] Overlimit: #{failed_count}"
          raise e
        end
      end
    end
    logger.info "[FETCH END] from #{end_num}"
  end

  def self.crowl_from_max(renge)
    max_num = self.order('profile_id DESC').first.try(:profile_id) || 0
    crowl_numeric(max_num + 1, renge)
  end

  def self.update_data(period = 3.day)
    transaction do
      self.where("updated_at < ?", period.ago).each do |user|
        fetch_and_save!(user.profile_id)
      end
    end
  end

  def self.refresh_rank
    self.transaction do
      User.update_all('rank = ?', nil)
      User.order("total_downloads DESC").each_with_index do |user, index|
        user.rank = index + 1
        user.save
      end
    end
  end

  class Fetcher
    def self.get(profile_id)
      new.get(profile_id)
    end

    def agent
      @agent ||= Mechanize.new
    end

    def get(profile_id)
      page = agent.get("http://rubygems.org/profiles/#{profile_id}")
      name = page.search("#profile-name").inner_text
      total_downloads = page.search("#downloads_count strong").map(&:inner_text).map{|t| t.gsub(',', "")}.map(&:to_i).max
      encoded_email = page.search('#profile-email a').attr('href').to_s.gsub('mailto:', "")
      email = URI.decode(encoded_email)
      { handle: name, total_downloads: total_downloads, email: email }
    end
  end
end
