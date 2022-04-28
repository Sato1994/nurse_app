# frozen_string_literal: true

class Agreement < ApplicationRecord
  belongs_to :user
  belongs_to :host
  belongs_to :room
  has_one :cancell_comment
  has_one :rate
  has_many :user_notices, as: :source
  has_many :host_notices, as: :source

  validates :room_id, uniqueness: true
  validates :start_time, presence: true
  validates :finish_time, presence: true
  validates :state, inclusion: { in: %w[before during finished requesting cancelled] }

  validate :limitation_of_working_hours
  validate :agreement_has_some_hours_grace
  validate :duplication_of_work_hours_for_same_user

  enum state: { before: 0, during: 1, finished: 2, requesting: 3, cancelled: 4 }

  scope :in_progress, -> { where(state: %i[before during requesting]) }
  scope :not_in_progress, -> { where(state: %i[finished cancelled])}
  scope :in_finished, -> { where(state: %i[finished])}

  def limitation_of_working_hours
    unless finish_time >= (start_time + 1.hour) && (start_time + 18.hours) >= finish_time
      errors.add(:message,
                 '勤務時間は1～18時間までです。')
    end
  end

  def agreement_has_some_hours_grace
    errors.add(:message, '勤務開始時間は現在時刻より6時間以上の猶予が必要です。') unless start_time > (6.hours.from_now)
  end

  def duplication_of_work_hours_for_same_user
    room = Room.find(room_id)
    if room.agreement.nil?
      # 新規
      if Agreement.exists?(['finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id])
        errors.add(:message, '看護師の勤務期間が他の契約と重複しています')
      end
    else
      # 更新
      agreement = room.agreement
      if Agreement.exists?(['id != ? && finish_time >= ? && ? >= start_time && user_id = ?', agreement.id, start_time,
                            finish_time, user_id])
        errors.add(:message, '看護師の勤務期間が他の契約と重複しています。')
      end
    end
  end

  def update_state
    transaction do
      update(state: 'requesting')
      room.update(state: 'negotiating')
    end

    {
      agreement: {
        state: self.state,
        id: self.id
      },
      room: {
        state: room.state,
        id: room.id
      }
    }
  rescue StandardError
    nil
  end

  def cancell_agreement
    transaction do
      update(state: 'cancelled')
      room.update(state: 'cancelled')
    end
  end

  def self.update_to_correct_state
    now = Time.current.freeze
    where('start_time <= ? && ? < finish_time && state = 0', now, now).update_all(state: 'during')
    where(state: %i[before during]).where('finish_time <= ?', now).update_all(state: 'finished')
    where(state: 'requesting').where('start_time <= ?', now + 6.hours).update_all(state: 'cancelled')
  end
end
