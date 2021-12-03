class RenameConsensusColumnToRooms < ActiveRecord::Migration[6.0]
  def change
    rename_column :rooms, :consensus, :state
    rename_column :rooms, :deletion, :closed
  end
end
