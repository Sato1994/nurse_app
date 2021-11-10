class RecruitmentTime < ApplicationRecord
  belongs_to :host
  has_many :user_requests, dependent: :destroy

  validates :host, presence: true
  validates :start_time, presence: true
  validates :finish_time, presence: true

  validate :duplication_of_recruitment_time_for_same_host
  validate :recruitment_time_has_some_hours_grace
  validate :limitation_of_recruitment_time

  




  def duplication_of_recruitment_time_for_same_host
    if RecruitmentTime.where('finish_time >= ? && ? >= start_time && host_id = ?', start_time, finish_time, host_id).exists?
     errors.add(:start_time, "登録時間が重複しています。")
    end
  end

  def limitation_of_recruitment_time
    unless finish_time >= (start_time + 1.hour)
      errors.add(:start_time, "登録時間は最低1時間以上です。")
    end
  end

  def recruitment_time_has_some_hours_grace
    unless start_time > (Time.current + 12.hour)
      errors.add(:start_time, "登録時間は現在時刻より12時間以上時間の猶予が必要です。")
    end
  end










end
