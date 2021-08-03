class FreeTime < ApplicationRecord
  belongs_to :user

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
    if Agreement.where('finish_time >= ? && ? >= start_time && user_id = ? && state != ?', start_time, finish_time, user_id, 4).exists?
      errors.add(:start_time, "登録時間が勤務予定時間と重複しています。")
    end
  end

  def limitation_of_free_time
    unless finish_time >= (start_time + 1.hour)
      errors.add(:start_time, "登録時間は最低1時間以上です。")
    end
  end

  # 登録時間は現時刻から12時間後から可能(agreementnお現時刻との猶予を6時間以上に直す。)
  def free_time_has_some_hours_grace
    unless start_time > (Time.current + 12.hour)
      errors.add(:start_time, "登録時間は現在時刻より12時間以上時間の猶予が必要です。")
    end
  end

  
  











end