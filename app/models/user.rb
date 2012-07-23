class User < ActiveRecord::Base
  attr_accessible :email, :handle, :profile_id, :total_downloads

  has_many :memberships
  has_many :teams, through: :memberships

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
      self.update_all({ rank: nil })
      self.order("total_downloads DESC").each_with_index do |user, index|
        self.where(id: user.id).update_all(rank: index + 1)
      end
    end
  end

end
