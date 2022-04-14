# frozen_string_literal: true

class Api::UserNoticesController < ApplicationController
  def index
    return unless api_user_signed_in?

    notices = UserNotice.where(user_id: current_api_user.id, checked: false)
    .includes(source: [:host, :room])
    .order(created_at: :desc)

    render_notices = notices.as_json(
      only: %i[action checked created_at id source_id source_type],
      include: {
        source: {
          only: [],
          include: {
            host: {
              only: %i[name myid image]
            }
          }
        }
      }
    )

    render_notices.each do |notice|
      notice['source']['partner'] = notice['source'].delete('host')
      if notice['source_type'] === 'Agreement'
        notice['source']['room'] = {'id': notices.find(notice['id']).source.room.id}
      end
    end

    render json: render_notices

  end

  def destroy
    user_notice = UserNotice.find(params[:id])
    return unless user_login_and_own?(user_notice.user_id)

    render_message '削除されました。', :ok if user_notice.destroy
  end
end
