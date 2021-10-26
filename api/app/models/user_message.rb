class UserMessage < ApplicationRecord  
  belongs_to :room

  validates :message, presence: true, length: { maximum: 500 }




end
