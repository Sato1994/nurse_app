class AddFreeTimeToHostRequests < ActiveRecord::Migration[6.0]
  def change
    add_reference :host_requests, :free_time, foreign_key: true, null: false
  end
end
