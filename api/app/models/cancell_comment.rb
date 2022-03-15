# frozen_string_literal: true

class CancellComment < ApplicationRecord
  belongs_to :agreement
  has_one :user, through: :agreement

  validates :agreement, uniqueness: true
  validates :comment, presence: true, length: { maximum: 50 }
end
