# frozen_string_literal: true

class HostMessage < ApplicationRecord
  belongs_to :room
  has_one :host, through: :room

  validates :message, presence: true, length: { maximum: 500 }
end
