class FreeTime < ApplicationRecord
  belongs_to :user
  has_many :host_requests, dependent: :destroy

  validates :user, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true

  validate :duplication_of_free_time_for_same_user
  validate :duplication_of_agreement_for_same_user
  validate :limitation_of_free_time
  validate :free_time_has_some_hours_grace

  def duplication_of_free_time_for_same_user
   if FreeTime.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
    errors.add(:start_time, "登録時間が重複しています。")
   end
  end

  def duplication_of_agreement_for_same_user
    if Agreement.where('finish_time >= ? && ? >= start_time && user_id = ?', start_time, finish_time, user_id).exists?
      errors.add(:start_time, "一度契約した時間では登録できません。")
    end
  end

  def limitation_of_free_time
    unless finish_time >= (start_time + 1.hour)
      errors.add(:start_time, "登録時間は最低1時間以上です。")
    end
  end

  def free_time_has_some_hours_grace
    unless start_time > (Time.current + 12.hour)
      errors.add(:start_time, "登録時間は現在時刻より12時間以上時間の猶予が必要です。")
    end
  end
end
