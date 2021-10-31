class HostSkill < ApplicationRecord
  belongs_to :host
  belongs_to :skill

  validates :host_id, presence: true
  validates :skill_id, presence: true
  validates_uniqueness_of :skill_id, :scope => :host_id
end
