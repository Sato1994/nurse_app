class AddIndexToUserRequests < ActiveRecord::Migration[6.0]
  def change
    add_index :user_requests, [:user_id, :recruitment_time_id], unique: true
  end
end
