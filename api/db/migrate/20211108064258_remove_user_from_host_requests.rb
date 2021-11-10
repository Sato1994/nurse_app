class RemoveUserFromHostRequests < ActiveRecord::Migration[6.0]
  def change
    remove_reference :host_requests, :user, null: false, foreign_key: true
  end
end
