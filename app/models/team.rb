class Team < ActiveRecord::Base
  attr_accessible :name, :url

  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true

  def update_all_ranks
    self.memberships.update_all(rank: nil)
    self.memberships.includes(:user).order('users.total_downloads DESC').each_with_index do |membership, index|
      Membership.where(id: membership.id).update_all(rank: index + 1)
    end
  end
end
