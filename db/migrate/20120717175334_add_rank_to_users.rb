class AddRankToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rank, :integer

    add_index :users, :rank
    add_index :users, :total_downloads
  end
end
