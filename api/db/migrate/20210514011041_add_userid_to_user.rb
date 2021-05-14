class AddUseridToUser < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :myid, :string, null: false
    add_column :hosts, :myid, :string, null: false
    add_index :users, :myid, unique: true
    add_index :hosts, :myid, unique: true
  end
end
