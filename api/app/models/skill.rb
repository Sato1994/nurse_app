class Skill < ApplicationRecord

  has_many :user_skills, dependent: :destroy
  has_many :users, through: :user_skills

  validates :name, uniqueness: true, presence: true, length: { maximum: 30 }


end