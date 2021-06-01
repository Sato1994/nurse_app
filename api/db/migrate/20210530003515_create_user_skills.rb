class CreateUserSkills < ActiveRecord::Migration[6.0]
  def change
    create_table :user_skills do |t|
      t.references :user, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps

      #ペアの重複をさせない
      t.index [:user_id, :skill_id], unique: true
    end
  end
end
