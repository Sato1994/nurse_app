class AddIndexToCancellCommentsAgreement < ActiveRecord::Migration[6.0]
  def change
    add_index :cancell_comments, :agreement, unique: true
  end
end
