class AddRoomIdToAgreements < ActiveRecord::Migration[6.0]
  def change
    add_reference :agreements, :room, null: false, foreign_key: true
  end
end
