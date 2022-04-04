# frozen_string_literal: true

class Api::HostNoticesController < ApplicationController
  def index
    return unless api_host_signed_in?
    notices = HostNotice.where(host_id: current_api_host.id, checked: false).includes(source: :user)
    render json: notices.as_json(
      only: %i[action checked created_at id source_id source_type],
      include: {
        source: {
          only: [],
          include: {
            user: {
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
    #       include: :user
    #     }
    #   }
    # )
  end
end
