class AddDeletedAtColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :deleted_at, :datetime

    add_column :hosts, :deleted_at, :datetime
  end
end
