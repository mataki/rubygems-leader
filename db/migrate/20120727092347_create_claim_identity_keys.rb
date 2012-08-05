class CreateClaimIdentityKeys < ActiveRecord::Migration
  def change
    create_table :claim_identity_keys do |t|
     t.references :user
     t.string :key

     t.timestamps
    end
    add_index :claim_identity_keys, :user_id
  end
end
