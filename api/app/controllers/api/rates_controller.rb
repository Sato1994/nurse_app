# frozen_string_literal: true

class Api::RatesController < ApplicationController
  def show
    host = Host.find_by(myid: params[:id])
    rates = Rate.left_joins(:agreement).includes(agreement: :user).merge(Agreement.where(host_id: host.id))
    render json: { rates: rates.as_json(
      only: %i[id star comment],
      include: {
        agreement: {
          only: %i[start_time],
          include: {
            user: {
              only: %i[age sex]
            },
            host: {
              only: %i[name]
            }

          }
        }
      }
    ),
                   host_name: host.name }

    # 確認用
    # render json: rates.as_json(
    #   include: {
    #     agreement: {
    #       include: {
    #         user: {
    #         },
    #         host: {
    #         }
    #       }
    #     }
    #   }
    # )
  end

  def create
    agreement = Agreement.find(params[:agreement_id])
    unless user_login_and_own?(agreement.user_id)
      render_message '適切なユーザーでログインしてください。', :unauthorized
      return
    end

    unless agreement.state == 'finished'
      render_message '勤務終了までは評価できません。', :bad_request
      return
    end

    rate = Rate.new(rate_params)
    if rate.save
      rate.create_host_notice!(host_id: rate.host.id, action: 'created')
      render_message '勤務お疲れさまでした。', :ok
    else
      render json: rate.errors
    end
  end

  private

  def rate_params
    params.permit(:comment, :star).merge(agreement_id: params[:agreement_id])
  end
end
