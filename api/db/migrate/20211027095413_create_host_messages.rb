class CreateHostMessages < ActiveRecord::Migration[6.0]
  def change
    create_table :host_messages do |t|
      t.text :message, null: false
      t.references :room, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
