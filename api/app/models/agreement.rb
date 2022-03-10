class Agreement < ApplicationRecord
  belongs_to :user
  belongs_to :host
  belongs_to :room

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
    unless finish_time >= (start_time + 1.hour) && (start_time + 18.hour) >= finish_time
      errors.add(:finish_time, "勤務時間は1～18時間までです。")
    end
  end

  def agreement_has_some_hours_grace
    unless start_time > (Time.current + 6.hour)
      errors.add(:start_time, "勤務開始時間は現在時刻より6時間以上の猶予が必要です。")
    end
  end

  def duplication_of_work_hours_for_same_user
    room = Room.find(room_id)
    if room.agreement.nil?
      if Agreement.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
      errors.add(:start_time, "看護師の勤務期間が他の契約と重複しています")
      end
    else
      agreement = room.agreement
      if Agreement.where('id != ? && finish_time >= ? && ? >= start_time && user_id = ?', agreement.id, start_time, finish_time, user_id).exists?
        errors.add(:start_time, "看護師の勤務期間が他の契約と重複しています。")
      end
    end
  end

  def update_state
    begin
      self.transaction do
        self.update_attribute(:state, "requesting")
        self.room.update_attribute(:state, "negotiating")
      end
      obj = {agreement: self, room: self.room}
      return obj
    rescue 
      return 
    end
  end

  def cancell_agreement
    begin
      self.transaction do
        self.update_attribute(:state, "cancelled")
        self.room.update_attribute(:state, "cancelled")
      end
    end
  end

  def self.update_state_when_view_index(id, me)
    # stateが0のものは勤務時間であればにstateを1に変更。
    # stateが0か1のもののうち勤務時間を超えていれば2へ変更
    self.where("#{me}_id = ? && start_time <= ? && ? <= finish_time && state = 0", id, Time.current,
      Time.current).update_all(state: 1)
    self.where("#{me}_id = ? && finish_time < ? && (state = 0 || 1)", id,
    Time.current).update_all(state: 2)
  end
end