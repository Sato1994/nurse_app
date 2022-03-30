class UserNotice < ApplicationRecord
  belongs_to :source, polymorphic: true, optional: true

  belongs_to :user
end
