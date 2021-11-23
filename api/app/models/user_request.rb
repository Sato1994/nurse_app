class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :recruitment_time
  has_one :host, through: :recruitment_time

  validates :user, presence: true
  validates :recruitment_time, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates_uniqueness_of :recruitment_time_id, scope: :user_id
  
  validate :is_the_request_included_in_the_recruitment_time
  validate :duplication_of_user_request
  validate :duplication_of_agreement
  validate :user_request_has_some_hours_grace
  validate :limitation_of_user_request_hours

  def is_the_request_included_in_the_recruitment_time
    unless RecruitmentTime.where('start_time <= ? && finish_time >= ? && id = ?', start_time, finish_time, recruitment_time_id).exists?
      errors.add(:start_time, "病院の募集時間の範囲を超えています。")
    end
  end
  
  def duplication_of_user_request
    if UserRequest.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
      errors.add(:start_time, "同じ時間帯で申請済みです。")
    end
  end

  def duplication_of_agreement
    if Agreement.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
      errors.add(:start_time, "同じ時間帯で契約済みです。")
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
