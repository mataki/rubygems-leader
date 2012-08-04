require 'securerandom'
class ClaimIdentityKey < ActiveRecord::Base

  attr_accessible :user_id, :key, :github_user_id

  belongs_to :user
  belongs_to :github_user

  validates :github_user, presence: true
  validates :user, presence: true

  before_create :create_hash_key
  delegate :email, to: :user

  def expired?
    created_at < Time.zone.now - 2.hours
  end

  def associate_accounts!
    return if expired?
    ref_github_user = github_user.associate_with_user user
    self.delete
    ref_github_user
  end

  private

  def create_hash_key
    self.key = SecureRandom.uuid
  end

end
