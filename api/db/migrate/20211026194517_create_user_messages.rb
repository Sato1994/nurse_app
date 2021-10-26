class CreateUserMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :user_messages do |t|
      t.text :message, null: false
      t.references :room, null: false, foreign_key: true

      t.timestamps
    end
  end
end