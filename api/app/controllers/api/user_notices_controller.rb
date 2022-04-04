# frozen_string_literal: true

class Api::UserNoticesController < ApplicationController
  def index
    return unless api_user_signed_in?

    notices = UserNotice.where(user_id: current_api_user.id, checked: false).includes(source: :host)
    render json: notices.as_json(
      only: %i[action checked created_at id source_id source_type],
      include: {
        source: {
          only: [],
          include: {
            host: {
              only: %i[name myid]
            }
          }
        }
      }
    )

    # 確認用
    # render json: notices.as_json(
    #   include: {
    #     source: {
    #       include: :host
    #     }
    #   }
    # )
  end
end
