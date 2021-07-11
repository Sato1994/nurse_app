class CreateUserRequests < ActiveRecord::Migration[6.0]
  def change
    create_table :user_requests do |t|
      t.datetime :start_time, null: false
      t.datetime :finish_time, null: false
      t.references :user, null: false, foreign_key: true
      t.references :host, null: false, foreign_key: true

      t.timestamps
    end
  end
end
