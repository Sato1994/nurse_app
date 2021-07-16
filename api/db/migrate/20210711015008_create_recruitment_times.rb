class CreateRecruitmentTimes < ActiveRecord::Migration[6.0]
  def change
    create_table :recruitment_times do |t|
      t.datetime :start_time , null: false
      t.datetime :finish_time, null: false
      t.references :host, null: false, foreign_key: true

      t.timestamps
    end
  end
end
