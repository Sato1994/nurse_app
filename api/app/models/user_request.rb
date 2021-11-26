class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :recruitment_time
  has_one :host, through: :recruitment_time

  validates :user, presence: true
  validates :recruitment_time, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  
  validate :is_the_request_included_in_the_recruitment_time
  validate :duplication_of_user_request
  validate :duplication_of_host_request
  validate :duplication_of_agreement
  validate :duplication_of_room
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

  def duplication_of_host_request
    recruitment_time = RecruitmentTime.find(recruitment_time_id)
    host = recruitment_time.host
    if HostRequest.includes(free_time: :user).where('host_id = ? && users.id = ? && host_requests.finish_time >= ? && ? >= host_requests.start_time', host.id, user_id, start_time, finish_time).references(:users, :free_times).exists?
      errors.add(:start_time, "同じ時間帯でお相手から申請が来ています。")
    end
  end

  def duplication_of_agreement
    if Agreement.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
      errors.add(:start_time, "同じ時間帯で契約済みです。")
    end
  end

  def duplication_of_room
    recruitment_time = RecruitmentTime.find(recruitment_time_id)
    host = recruitment_time.host
    if Room.where('user_id = ? && host_id = ? && finish_time >= ? && ? >= start_time', user_id, host.id, start_time, finish_time).exists?
      errors.add(:start_time, "同じ時間帯でお相手と交渉中です。")
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
