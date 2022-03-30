class CreateHostNotices < ActiveRecord::Migration[6.0]
  def change
    create_table :host_notices do |t|
      t.string :action, null: false
      t.references :host, null: false, foreign_key: true
      t.references :source, null: false, polymorphic: true
      t.boolean :checked, null: false, default: false
      t.timestamps
    end
  end
end
