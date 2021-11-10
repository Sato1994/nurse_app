class RemoveHostIdFromUserRequests < ActiveRecord::Migration[6.0]
  def change
    remove_reference :user_requests, :host, null: false, foreign_key: true
  end
end
