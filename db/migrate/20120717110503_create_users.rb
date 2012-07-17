class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :handle
      t.integer :profile_id
      t.integer :total_downloads

      t.timestamps
    end
  end
end
