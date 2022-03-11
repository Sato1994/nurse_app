# frozen_string_literal: true

class UserMessage < ApplicationRecord
  belongs_to :room
  has_one :user, through: :room

  validates :message, presence: true, length: { maximum: 500 }
end
