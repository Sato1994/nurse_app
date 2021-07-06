class Agreement < ApplicationRecord
  belongs_to :user
  belongs_to :host

  validates :user, presence: :true
  validates :host, presence: :true
  validates :start_time, presence: :true
  validates :finish_time, presence: :true
  validates :state, inclusion: { in: %w(申請中 勤務期間前 勤務期間中 勤務完了 変更申請中 キャンセル済) }

  validate :limitation_of_working_hours
  validate :start_time_has_some_hours_grace
  validate :duplication_of_work_hours_for_same_user

  enum state: { 申請中: 0, 勤務期間前: 1, 勤務期間中: 2, 勤務完了: 3, 変更申請中: 4, キャンセル済: 5 }

  def limitation_of_working_hours
    unless finish_time >= (start_time + 1.hour) && (start_time + 18.hour) >= finish_time
      errors.add(:finish_time, "勤務時間は1～18時間までです。")
    end
  end

  def start_time_has_some_hours_grace
    unless start_time > (Time.current + 12.hour)
      errors.add(:start_time, "勤務開始時間は現在時刻より12時間以上の猶予が必要です。")
    end
  end

  def duplication_of_work_hours_for_same_user
    result = Agreement.where('finish_time >= ? && ? >= start_time && user_id = ? && state != ?', start_time, finish_time, user_id, 5)
    unless result.blank?
       errors.add(:start_time, "勤務時間が他の勤務時間と重複しています。")
    end
  end
end