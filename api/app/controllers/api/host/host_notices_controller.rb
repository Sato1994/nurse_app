# frozen_string_literal: true

class Api::Host::HostNoticesController < ApplicationController
  def index
    return unless api_host_signed_in?

    notices = HostNotice.where(host_id: current_api_host.id, checked: false)
    .includes(source: [:user, :room])
    .order(created_at: :desc) 

    render_notices = notices.as_json(
      only: %i[action checked created_at id source_id source_type],
      include: {
        source: {
          only: [],
          include: {
            user: {
              only: %i[name myid image]
            }
          }
        }
      }
    )

    render_notices.each do |notice|
      notice['source']['partner'] = notice['source'].delete('user')
      if notice['source_type'] === 'Agreement'
        notice['source']['room'] = {'id': notices.find(notice['id']).source.room.id}
      end
    end

    render json: render_notices

  end

  def destroy
    host_notice = HostNotice.find(params[:id])
    return unless host_login_and_own?(host_notice.host_id)

    render_message '削除されました。', :ok if host_notice.destroy
  end
end
