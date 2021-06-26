class Agreement < ApplicationRecord
  belongs_to :user
  belongs_to :host

  validates :user, presence: :true
  validates :host, presence: :true
  validates :start_time, presence: :true
  validates :finish_time, presence: :true
  validates :state, presence: :true, numericality: { in: 0..5 }

  enum state: { 申請中: 0, 勤務期間前: 1, 勤務期間中: 2, 勤務完了: 3, 変更申請中: 4, キャンセル済: 5 }

end
