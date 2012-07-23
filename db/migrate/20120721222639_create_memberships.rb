class CreateMemberships < ActiveRecord::Migration
  def change
    create_table :memberships do |t|
      t.references :team
      t.references :user
      t.integer :rank

      t.timestamps
    end
    add_index :memberships, :team_id
    add_index :memberships, :user_id
  end
end
