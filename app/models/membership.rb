class Membership < ActiveRecord::Base
  attr_accessible :user_name

  belongs_to :team
  belongs_to :user

  validates :team, presence: true
  validates :user, presence: true
  validates :user_id, uniqueness: { scope: :team_id }

  def user_name=(name)
    self.user = User.find_by_handle(name)
  end

  def user_name
    self.user.try(:handle)
  end

  after_save :update_team_rank
  after_destroy :update_team_rank
  def update_team_rank
    self.team.update_all_ranks
  end
end
