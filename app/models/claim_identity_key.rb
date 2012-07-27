require 'securerandom'
# A 'one time' key with a two our expiration.
# This is used when the user requirest to alter their coderwall name and will need to be 
# altered to include scope when or if we decide to include other mashup sources.
# However, at that point, I would expect that we should refactor user and accounts out into a one to many relationship with types
# And require the user to authenticate via email to the Rubygems account email address.
class ClaimIdentityKey < ActiveRecord::Base

  after_initialize :create_hash_key

  attr_accessible :user, :key

  belongs_to :user

  validates :user, presence: true

  def expired?
    return false unless created_at
    created_at < Time.zone.now - 2.hours
  end

  private

  def create_hash_key
    self.key = SecureRandom.uuid
  end

end
