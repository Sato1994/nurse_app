# frozen_string_literal: true

class HostNotice < ApplicationRecord
  belongs_to :source, polymorphic: true, optional: true
  belongs_to :host

  # https://github.com/Sato1994/nurse_app/issues/199
  validates :action, presence: true, inclusion: { in: %w[created left agreed changed cancelled] }
  validates :checked, inclusion: { in: [true, false] }
  validates :source, presence: true
end
