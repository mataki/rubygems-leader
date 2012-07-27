class AddCoderwallNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :coderwall_name, :string
  end
end
