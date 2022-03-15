class CreateCancellComments < ActiveRecord::Migration[6.0]
  def change
    create_table :cancell_comments do |t|
      t.references :agreement, null: false, foreign_key: true
      t.text :comment

      t.timestamps


    end
  end
end
