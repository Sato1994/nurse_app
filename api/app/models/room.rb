class Room < ApplicationRecord
  belongs_to :user
  belongs_to :host

  validates :user, presence: :true
  validates :host, presence: :true
end
