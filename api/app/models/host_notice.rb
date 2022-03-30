class HostNotice < ApplicationRecord
  belongs_to :source, polymorphic: true, optional: true

  belongs_to :host
end
