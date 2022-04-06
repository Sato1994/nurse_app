# frozen_string_literal: true

class HostSkill < ApplicationRecord
  belongs_to :host
  belongs_to :skill

  validates :host_id, presence: true
  validates :skill_id, presence: true
  validates :skill_id, uniqueness: { scope: :host_id }
end
