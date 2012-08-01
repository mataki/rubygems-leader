class User < ActiveRecord::Base
  attr_accessible :email, :handle, :profile_id, :total_downloads, :coderwall_name

  has_many :memberships
  has_many :teams, through: :memberships
  has_many :rank_histories
  has_many :claim_identity_keys
  has_one :github_user
  
  validates :handle, presence: true
  validates :email, presence: true
  validates :profile_id, presence: true

  validates_uniqueness_of :profile_id

  def fetcher
    @fetcher ||= Fetcher.new(self)
  end

  def update_facts
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
      # SQL-FU - NOTE this will only work on postgres!!
      # deep_rank() would be better than row_number(), but it will break our lively pagination based searching as many
      # users can have the same ranking
sql = "update users
               set rank = d_rnk
               from (SELECT id,row_number() OVER (ORDER BY total_downloads DESC) as d_rnk FROM users) as ranked
               where ranked.id = users.id;"
      ActiveRecord::Base.connection.execute(sql)
    end
  end

  def self.create_rank_histories
    self.transaction do
      self.find_in_batches do |group|
        group.each do |user|
          user.rank_histories.create(rank: user.rank)
        end
      end
    end
  end
end
