class CreateGithubUsers < ActiveRecord::Migration
  def change
    create_table :github_users do |t|
      t.integer :user_id
      t.string :uid
      t.string :email
      t.string :login

      t.timestamps
    end
  end
end
