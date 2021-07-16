class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :host

  validates :user, presence: true
  validates :host, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  
  validate :is_the_request_included_in_the_recruitment_time
  validate :duplication_of_user_request_for_same_user
  validate :user_request_has_some_hours_grace
  validate :limitation_of_user_request_hours




  def is_the_request_included_in_the_recruitment_time
    unless RecruitmentTime.where('start_time <= ? && finish_time >= ? && host_id = ?', start_time, finish_time, host_id).exists?
      errors.add(:start_time, "病院の募集時間の範囲を超えています。")
    end
  end
  
  def duplication_of_user_request_for_same_user
    if UserRequest.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
      errors.add(:start_time, "同じ時間帯で申請済みです。")
    end
  end

  def user_request_has_some_hours_grace
    unless start_time > (Time.current + 7.hour)
      errors.add(:start_time, "申請時間は現時刻より7時間以上の猶予が必要です。")
    end
  end

  def limitation_of_user_request_hours
    unless finish_time >= (start_time + 1.hour)
      errors.add(:start_time, "申請時間は最低1時間以上です。")
    end
  end

end
