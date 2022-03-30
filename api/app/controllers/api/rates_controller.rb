# frozen_string_literal: true

class Api::RatesController < ApplicationController
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
