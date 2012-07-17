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
    (start_num...end_num).each do |i|
      begin
        fetch_and_save!(i)
      rescue => e
        logger.error "[Fetch Error] profile_id: #{i}"
        logger.error e
      end
    end
    logger.info "[FETCH END] from #{end_num}"
  end

  def self.crowl_from_max(renge)
    max_num = self.order('profile_id DESC').first.try(:profile_id) || 0
    crowl_numeric(max_num + 1, renge)
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
