class Skill < ApplicationRecord

  validates :name, uniqueness: true, presence: true, length: { maximum: 30 }


end