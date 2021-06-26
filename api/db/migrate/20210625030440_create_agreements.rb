class CreateAgreements < ActiveRecord::Migration[6.0]
  def change
    create_table :agreements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :host, null: false, foreign_key: true
      t.time :start_time, null: false
      t.time :finish_time, null: false
      t.integer :states, null: false, default: 0

      t.timestamps
    end
  end
end
