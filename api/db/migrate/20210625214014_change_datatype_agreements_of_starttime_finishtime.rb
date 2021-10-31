class ChangeDatatypeAgreementsOfStarttimeFinishtime < ActiveRecord::Migration[6.0]
  def change
    change_column :agreements, :start_time, :datetime
    change_column :agreements, :finish_time, :datetime
  end
end
