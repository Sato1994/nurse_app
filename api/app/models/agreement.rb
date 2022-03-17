# frozen_string_literal: true

class Agreement < ApplicationRecord
  belongs_to :user
  belongs_to :host
  belongs_to :room
  has_one :cancell_comment

  validates :user, presence: :true
  validates :host, presence: :true
  validates :room, presence: :true
  validates_uniqueness_of :room_id
  validates :start_time, presence: :true
  validates :finish_time, presence: :true
  validates :state, inclusion: { in: %w(before during finished requesting cancelled) }

  validate :limitation_of_working_hours
  validate :agreement_has_some_hours_grace
  validate :duplication_of_work_hours_for_same_user

  enum state: { before: 0, during: 1, finished: 2, requesting: 3, cancelled: 4 }

  def limitation_of_working_hours
    unless finish_time >= (start_time + 1.hour) && (start_time + 18.hours) >= finish_time
      errors.add(:finish_time,
                 '勤務時間は1～18時間までです。')
    end
  end

  def agreement_has_some_hours_grace
    errors.add(:start_time, '勤務開始時間は現在時刻より6時間以上の猶予が必要です。') unless start_time > (6.hours.from_now)
  end

  def duplication_of_work_hours_for_same_user
    room = Room.find(room_id)
    if room.agreement.nil?
      # 新規
      if Agreement.exists?(['finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id])
        errors.add(:start_time, '看護師の勤務期間が他の契約と重複しています')
      end
    else
      # 更新
      agreement = room.agreement
      if Agreement.exists?(['id != ? && finish_time >= ? && ? >= start_time && user_id = ?', agreement.id, start_time,
                            finish_time, user_id])
        errors.add(:start_time, '看護師の勤務期間が他の契約と重複しています。')
      end
    end
  end

  def update_state
    transaction do
      update(state: 'requesting')
      room.update(state: 'negotiating')
    end
    { agreement: self, room: room }
  rescue StandardError
    nil
  end

  def cancell_agreement
    transaction do
      update(state: 'cancelled')
      room.update(state: 'cancelled')
    end
  end

  def self.update_state_when_view_index(id, me)
    # stateが0のものは勤務時間であればにstateを1に変更。
    # stateが0か1のもののうち勤務時間を超えていれば2へ変更
    where("#{me}_id = ? && start_time <= ? && ? <= finish_time && state = 0", id, Time.current,
          Time.current).update_all(state: 1)
    where("#{me}_id = ? && finish_time < ? && (state = 0 || 1)", id,
          Time.current).update_all(state: 2)
  end
end
