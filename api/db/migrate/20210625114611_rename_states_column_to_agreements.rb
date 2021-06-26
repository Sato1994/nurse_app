class RenameStatesColumnToAgreements < ActiveRecord::Migration[6.0]
  def change
    rename_column :agreements, :states, :state
  end
end
