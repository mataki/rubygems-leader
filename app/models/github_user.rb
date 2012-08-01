class GithubUser < ActiveRecord::Base
  belongs_to :user
  
  attr_accessible :uid, :login, :email, :user

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

  def self.authenticate(data)
    parsed_data = parse_omniauth_data(data)
    user = User.find_by_email(parsed_data[:email])
    attr = parsed_data.merge({ user: user })
    gh_user = GithubUser.find_or_create_by_uid(attr)
    user.update_attributes(coderwall_name: gh_user.login) if user
    gh_user
  end

  private

  def self.parse_omniauth_data data
    { uid: data.uid.to_s,
      email: data.email,
      login: data.extra.raw_info.login }
  end
end
