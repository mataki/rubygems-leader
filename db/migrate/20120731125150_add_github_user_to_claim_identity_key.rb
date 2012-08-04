class AddGithubUserToClaimIdentityKey < ActiveRecord::Migration
  def change
    add_column :claim_identity_keys, :github_user_id, :integer
  end
end
