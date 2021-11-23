class AddTimeAndConsensusToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :start_time, :datetime, null: false
    add_column :rooms, :finish_time, :datetime, null: false
    add_column :rooms, :consensus, :integer, null: false, default: 0
    add_column :rooms, :deletion, :integer, null: false, default: 0
  end
end
