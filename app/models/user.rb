class User < ActiveRecord::Base
  attr_accessible :email, :handle, :profile_id, :total_downloads

  validates :handle, presence: true
  validates :email, presence: true
  validates :profile_id, presence: true

  validates_uniqueness_of :profile_id

  def fetcher
    @fetcher ||= Fetcher.new(profile_id)
  end

  def update_from_rubygems
    self.attributes = fetcher.get
    self.save!
  end

  def self.find_page_by_handle(handle, per)
    user = find_by_handle(handle)
    page = ((user.rank - 1) / per) + 1 if user
  end

  def self.refresh_rank
    self.transaction do
      User.update_all({ rank: nil })
      User.order("total_downloads DESC").each_with_index do |user, index|
        user.rank = index + 1
        user.save
      end
    end
  end

end
