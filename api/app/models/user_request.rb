# frozen_string_literal: true

class UserRequest < ApplicationRecord
  belongs_to :user
  belongs_to :recruitment_time
  has_one :host, through: :recruitment_time

  validates :user, presence: true
  validates :recruitment_time, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true

  validate :included_in_the_recruitment_time
  validate :duplication_of_user_request
  validate :duplication_of_host_request
  validate :duplication_of_agreement
  validate :duplication_of_room
  validate :user_request_has_some_hours_grace
  validate :limitation_of_user_request_hours

  def included_in_the_recruitment_time
    unless RecruitmentTime.exists?(['start_time <= ? && finish_time >= ? && id = ?', start_time, finish_time,
                                    recruitment_time_id])
      errors.add(:message, '病院の募集時間の範囲を超えています。')
    end
  end

  def duplication_of_user_request
    if UserRequest.exists?(['finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id])
      errors.add(:message, '同じ時間帯で申請済みです。')
    end
  end

  def duplication_of_host_request
    recruitment_time = RecruitmentTime.find(recruitment_time_id)
    host = recruitment_time.host
    if HostRequest.includes(free_time: :user).where('host_id = ? && users.id = ? && host_requests.finish_time >= ? && ? >= host_requests.start_time', host.id, user_id, start_time, finish_time).references(
      :users, :free_times
    ).exists?
      errors.add(:message, '同じ時間帯でお相手から申請が来ています。')
    end
  end

  def duplication_of_agreement
    if Agreement.exists?(['finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id])
      errors.add(:message, '同じ時間帯で契約済みです。')
    end
  end

  def duplication_of_room
    recruitment_time = RecruitmentTime.find(recruitment_time_id)
    host = recruitment_time.host
    if Room.exists?(['user_id = ? && host_id = ? && finish_time >= ? && ? >= start_time', user_id, host.id, start_time,
                     finish_time])
      errors.add(:message, '同じ時間帯でお相手と交渉中です。')
    end
  end

  def user_request_has_some_hours_grace
    errors.add(:message, '申請時間は現時刻より7時間以上の猶予が必要です。') unless start_time > (7.hours.from_now)
  end

  def limitation_of_user_request_hours
    errors.add(:message, '申請時間は最低1時間以上です。') unless finish_time >= (start_time + 1.hour)
  end
end
