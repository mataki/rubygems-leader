class User < ActiveRecord::Base
  attr_accessible :email, :handle, :profile_id, :total_downloads

  has_many :memberships
  has_many :teams, through: :memberships
  has_many :rank_histories

  validates :handle, presence: true
  validates :email, presence: true
  validates :profile_id, presence: true

  validates_uniqueness_of :profile_id

  def fetcher
    @fetcher ||= Fetcher.new(profile_id)
  end

  def update_from_rubygems
    self.attributes = fetcher.get
    if total_downloads > 0
      self.save!
    end
  end

  def self.find_page_by_handle(handle, per)
    user = find_by_handle(handle)
    page = ((user.rank - 1) / per) + 1 if user
  end

  def self.refresh_rank
    self.transaction do
      # SQL-FOO - NOTE this will only work on postgres!!
      sql = "update users
               set rank = d_rnk, updated_at = now()
               from (SELECT id,row_number() OVER (ORDER BY total_downloads DESC) as d_rnk FROM users) as ranked
               where ranked.id = users.id;"
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  def self.create_rank_histories
    self.find_in_batches do |group|
      group.each do |user|
        user.rank_histories.create(rank: self.rank)
      end
    end
  end
end
