class CreateFreeTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :free_times do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :start_time, null: false
      t.datetime :finish_time, null: false

      t.timestamps
    end
  end
end
