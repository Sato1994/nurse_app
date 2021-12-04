class Room < ApplicationRecord
  belongs_to :user
  belongs_to :host
  has_many :user_messages, dependent: :destroy
  has_many :host_messages, dependent: :destroy
  has_one :agreement

  validates :user, presence: :true
  validates :host, presence: :true
  validates :start_time, presence: :true
  validates :finish_time, presence: :true
  validates :state, inclusion: { in: %w( negotiating user host conclusion cancelled) }, presence: :true
  validates :closed, inclusion: { in: %w( na user host both) }, presence: :true

  validate :duplication_of_room_create, on: :create
  validate :duplication_of_room_update, on: :update
  validate :room_has_some_hours_grace
  validate :limitation_of_room_hours_max
  validate :limitation_of_room_hours_min

  enum state: { negotiating: 0, user: 1, host: 2, conclusion:3, cancelled: 4 }, _suffix: true
  enum closed: { na: 0, user: 1, host: 2, both: 3}, _suffix: true

  def duplication_of_room_create
    if Room.where('finish_time >= ? && ? >= start_time && user_id = ? && host_id = ?', start_time, finish_time, user_id, host_id).exists?
      errors.add(:start_time, "同じお相手と同じ時間帯で交渉中です。")
    end
  end

  def duplication_of_room_update
    if Room.where('finish_time >= ? && ? >= start_time && user_id = ? && host_id = ? && id != ?', start_time, finish_time, user_id, host_id, id).exists?
      errors.add(:start_time, "同じお相手と同じ時間帯で交渉中です。")
    end
  end

  def room_has_some_hours_grace
    unless start_time > (Time.current + 7.hour)
      errors.add(:start_time, "申請時間は現時刻から7時間以上の猶予が必要です。")
    end
  end

  def limitation_of_room_hours_max
    unless finish_time >= (start_time + 1.hour)
      errors.add(:start_time, "申請時間は最低1時間以上です。")
    end
  end
  
  def limitation_of_room_hours_min
    unless finish_time <= (start_time + 18.hour)
      errors.add(:start_time, "申請時間は最高18時間までです。")
    end
  end

  def update_closed(closed_value)
    self.update_attribute(:closed, closed_value)
  end

  def update_state(state_value)
    self.update_attribute(:state, state_value)
  end
end
