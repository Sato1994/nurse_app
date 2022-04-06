# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def create_user_notice!(payload)
    UserNotice.create(
      user_id: payload[:user_id],
      source: self,
      action: payload[:action]
    )
  end

  def create_user_notice_with_checked_validate!(payload)
    unless UserNotice.exists?(['source_id = ? && source_type = ? && action = ? && checked = false', id, self.class.name,
                               payload[:action]])
      UserNotice.create(
        user_id: payload[:user_id],
        source: self,
        action: payload[:action]
      )
    end
  end

  def create_host_notice!(payload)
    HostNotice.create(
      host_id: payload[:host_id],
      source: self,
      action: payload[:action]
    )
  end

  def create_host_notice_with_checked_validate!(payload)
    unless HostNotice.exists?(['source_id = ? && source_type = ? && action = ? && checked = false', id, self.class.name,
                               payload[:action]])
      HostNotice.create(
        host_id: payload[:host_id],
        source: self,
        action: payload[:action]
      )
    end
  end
end
