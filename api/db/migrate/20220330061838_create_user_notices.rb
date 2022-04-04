class CreateUserNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :user_notices do |t|
      t.string :action, null: false
      t.references :user, null: false, foreign_key: true
      t.references :source, null: false, polymorphic: true
      t.boolean :checked, null: false, default: false
      t.timestamps
    end
  end
end
