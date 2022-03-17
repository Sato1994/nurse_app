class AddColumnToHosts < ActiveRecord::Migration[6.0]
  def change
    add_column :hosts, :phone, :string, null: false
    
  end
end
