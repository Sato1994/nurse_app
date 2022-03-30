# frozen_string_literal: true

class Rate < ApplicationRecord
  belongs_to :agreement
  has_one :user, through: :agreement
  has_one :host, through: :agreement
  has_one :host_notice, as: :source, dependent: :destroy

  validates :star, presence: true,
                   numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5, allow_nil: false }
  validates :comment, presence: true, length: { maximum: 300 }
  validates :agreement_id, uniqueness: true
end
