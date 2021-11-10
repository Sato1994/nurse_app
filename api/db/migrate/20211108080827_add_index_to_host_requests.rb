class AddIndexToHostRequests < ActiveRecord::Migration[6.0]
  def change
    add_index :host_requests, [:host_id, :free_time_id], unique: true
  end
end
