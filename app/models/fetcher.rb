class Fetcher

  # instantiates a new fetcher for a specific rubygems profile
  # @param [Integer] user the user to fetch for
  def initialize(user)
    @user = user
  end

  attr_reader :user

  # TODO move this stuff out into a pair of jobs:
  # UpdateScheduler - spins off single UpdateUser jobs
  # UpdateUser - runs update_from_ruby_gems for the profile_id
  def self.fetch_and_save!(profile_id)
    user = User.find_or_initialize_by_profile_id(profile_id)
    user.update_facts
  end

  def self.crawl_numeric(start_num, range)
    logger.info "[FETCH START] from #{start_num}"
    end_num = start_num+range
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

  def self.crawl_from_max(range)
    max_num = User.order('profile_id DESC').first.try(:profile_id) || 0
    crawl_numeric(max_num + 1, range)
  end

  def self.update_data(period = 3.day, limit = 30)
    User.where("updated_at < ?", period.ago).order('updated_at ASC').limit(limit).each do |user|
      begin
        fetch_and_save!(user.profile_id)
      rescue => e
        logger.info "[update_data_error] #{e}: user: #{user.id}"
      end
    end
  end

  def self.get(user)
    new(user).get
  end

  def get
    @data ||= { handle: handle, total_downloads: total_downloads, email: email, coderwall_name: coderwall_name }
  end

  private

  def self.logger
    @@logger ||= ActiveRecord::Base.logger
  end

  def page
    @page ||= agent.get(Fetcher.fetch_url % @user.profile_id)
  end

  def handle
    page.search("#profile-name").inner_text
  end

  def coderwall_name
    begin
      Mechanize.new.get(Fetcher.coderwall_url % CGI::escape(handle))
      return handle
    rescue Mechanize::ResponseCodeError => e
      #noop
    end
  end

  def total_downloads
    humanized_values = page.search("#downloads_count strong").map(&:inner_text)
    integer_values = humanized_values.map do |downloads|
      downloads.gsub(',', "").to_i
    end
    integer_values.max
  end

  def email
    encoded_email = page.search('#profile-email a').attr('href')
    URI.decode encoded_email.to_s.gsub('mailto:', "")
  end

  def agent
    @agent ||= Mechanize.new
  end

  def self.coderwall_url
    @@coderwall_url ||= "http://coderwall.com/%s"
  end
  def self.fetch_url
    @@fetch_url ||= "http://rubygems.org/profiles/%s"
  end
end
