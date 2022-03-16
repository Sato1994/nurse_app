class CreateCancellComments < ActiveRecord::Migration[6.0]
  def change
    create_table :cancell_comments do |t|
      t.references :agreement, null: false, foreign_key: true, unique: true
      t.text :comment, null: false

      t.timestamps


    end
  end
end
