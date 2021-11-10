class AddRecruitmentTimeToUserRequests < ActiveRecord::Migration[6.0]
  def change
    add_reference :user_requests, :recruitment_time, foreign_key: true, null: false
  end
end
