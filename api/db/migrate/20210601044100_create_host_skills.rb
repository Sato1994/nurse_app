class CreateHostSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :host_skills do |t|
      t.references :host, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps

      t.index [:host_id, :skill_id], unique: true
    end
  end
end
