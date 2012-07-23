class CreateRankHistories < ActiveRecord::Migration
  def change
    create_table :rank_histories do |t|
      t.references :user
      t.integer :rank

      t.timestamps
    end
    add_index :rank_histories, :user_id
  end
end
