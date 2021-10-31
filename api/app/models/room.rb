class Room < ApplicationRecord
  belongs_to :user
  belongs_to :host

  has_many :user_messages, dependent: :destroy
  has_many :host_messages, dependent: :destroy

  validates :user, presence: :true
  validates :host, presence: :true
end
