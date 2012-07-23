class CreateScheduledUpdates < ActiveRecord::Migration
  def change
    create_table :scheduled_updates do |t|
      t.integer :profile_id
      t.string :status
      t.timestamps
      
    end
  end
end
