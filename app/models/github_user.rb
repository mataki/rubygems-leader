class GithubUser < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :uid, :login, :email, :user_id

  def request_identity(user_name)
    # reject any user that already has an associated github user
    return unless user = User.find_by_handle(user_name)
    return if user.github_user.is_a?(GithubUser)
    ClaimIdentityKey.create(user_id: user.id, github_user_id: self.id)
  end

  def self.confirm_identity(key)
    return unless identity_key = ClaimIdentityKey.find_by_key(key)
    identity_key.delete and return if identity_key.expired?
    identity_key.associate_accounts!
  end

  def self.authenticate(oauth_hash)
    find_or_create_by_oauth oauth_hash
  end

  def associate_with_user user
    return unless user.is_a?(User)
    self.update_attributes(user_id: user.id)
    user.update_attributes(coderwall_name: login)
    self
  end

  private
 
  def self.find_or_create_by_oauth oauth
    attr = parse_omniauth_data(oauth)
    gh_user = GithubUser.find_or_create_by_uid(attr)
    if user = User.find_by_email(gh_user.email)
      gh_user.associate_with_user user
    end
    gh_user
  end

  def self.parse_omniauth_data data
    { uid: data.uid.to_s,
      email: data.extra.raw_info.email,
      login: data.extra.raw_info.login }
  end
end
