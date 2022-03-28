class AddLatToUserHost < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :lat, :float, limit: 53
    add_column :users, :lng, :float, limit: 53

    add_column :hosts, :lat, :float, limit: 53
    add_column :hosts, :lng, :float, limit: 53
  end
end
