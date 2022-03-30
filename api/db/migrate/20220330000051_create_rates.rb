class CreateRates < ActiveRecord::Migration[6.0]
  def change
    create_table :rates do |t|
      t.integer :star, null: false
      t.text :comment, null: false
      t.references :agreement, null: false, foreign_key: true, unique: true

      t.timestamps
    end
  end
end
