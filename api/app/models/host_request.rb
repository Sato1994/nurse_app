class HostRequest < ApplicationRecord
  belongs_to :free_time
  belongs_to :host
  has_one :user, through: :free_time

  validates :free_time, presence: true
  validates :host, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  
  validate :is_the_request_included_in_the_free_time
  validate :duplication_of_host_request
  validate :duplication_of_user_request
  validate :duplication_of_room
  validate :host_request_has_some_hours_grace
  validate :limitation_of_host_request_hours

  def is_the_request_included_in_the_free_time
    unless FreeTime.where('start_time <= ? && finish_time >= ? && id = ?', start_time, finish_time, free_time_id).exists?
      errors.add(:start_time, "お相手の募集時間の範囲から外れています。")
    end
  end

  def duplication_of_host_request
    if HostRequest.where('finish_time >= ? && ? >= start_time && free_time_id = ? && host_id = ?', start_time, finish_time, free_time_id, host_id).exists?
      errors.add(:start_time, "同じ時間帯で申請済みです。")
    end
  end

  def duplication_of_user_request
    free_time = FreeTime.find(free_time_id)
    user = free_time.user
    if UserRequest.includes(recruitment_time: :host).where('user_id = ? && hosts.id = ? && user_requests.finish_time >= ? && ? >= user_requests.start_time', user.id, host_id, start_time, finish_time).references(:hosts, :recruitment_times).exists?
      errors.add(:start_time, "同じ時間帯でお相手から申請が来ています。")
    end
  end
  
  def duplication_of_room
    free_time = FreeTime.find(free_time_id)
    user = free_time.user
    if Room.where('user_id = ? && host_id = ? && finish_time >= ? && ? >= start_time', user.id, host_id, start_time, finish_time).exists?
      errors.add(:start_time, "同じ時間帯でお相手と交渉中です。")
    end
  end

  def host_request_has_some_hours_grace
    unless start_time > (Time.current + 7.hour)
      errors.add(:start_time, "申請時間は現時刻より7時間以上の猶予が必要です。")
    end
  end

  def limitation_of_host_request_hours
    unless finish_time >= (start_time + 1.hour)
      errors.add(:start_time, "申請時間は最低1時間以上です。")
    end
  end


end
