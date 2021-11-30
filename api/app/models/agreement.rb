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

  def update_state_consensus
      self.transaction do
        self.update_attribute(:state, "requesting")
        self.room.update_attribute(:consensus, "negotiating")
      end
      obj = {agreement: self, room: self.room}
       return obj
    rescue 
      return nil
  end
end