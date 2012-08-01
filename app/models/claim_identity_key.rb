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
    github_user.update_attributes(user: user)
    user.update_attributes(coderwall_name: github_user.login)
    self.delete
    github_user
  end

  private

  def create_hash_key
    self.key = SecureRandom.uuid
  end

end
