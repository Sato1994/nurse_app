# frozen_string_literal: true

class Api::AgreementsController < ApplicationController
  before_action :set_me, only: %i[index create]

  def index
    Agreement.update_state_when_view_index(@id, @me)
    @agreements = Agreement.where("#{@me}_id": @id)
    render 'index', formats: :json, handlers: :jbuilder
  end

  # agreement登録または時間の変更
  def create
    room = Room.find(params[:room_id])
    # agreementが未だ作られていない場合
    if room.agreement.nil?
      agreement = Agreement.new(eval("agreement_#{@me}_signed_in_params"))
      if agreement.save
        FreeTime.destroy_free_times(@user_id, Time.zone.parse(params[:start_time]),
                                    Time.zone.parse(params[:finish_time]))
        render json: agreement, status: :created
      else
        render json: agreement.errors, status: :bad_request
      end
    # agreementが既に存在した場合
    elsif room.agreement.update(eval("agreement_#{@me}_signed_in_params"))
      FreeTime.destroy_free_times(@user_id, Time.zone.parse(params[:start_time]),
                                  Time.zone.parse(params[:finish_time]))
      render json: room.agreement, status: :ok
    else
      render json: room.agreement.errors, status: :bad_request
    end
  end

  # agreementの変更申請
  def update
    agreement = Agreement.find(params[:id])
    if user_login_and_own?(agreement.user.id) || host_login_and_own?(agreement.host.id)
      if agreement.start_time > 24.hours.since
        render json: agreement.update_state
      else
        render body: nil, status: :bad_request
      end
    else
      render body: nil, status: :forbidden
    end
  end

  # agreementキャンセル
  def cancell
    agreement = Agreement.find(params[:id])
    return unless user_login_and_own?(agreement.user_id)

    if agreement.start_time > (30.days.from_now)
      agreement.cancell_agreement
    else
      if params[:comment].blank?
        render body: nil, status: :bad_request
        return
      end

      # cancell comment 作成
      cancell_comment = CancellComment.new(cancell_comment_params)
      agreement.cancell_agreement if cancell_comment.save
    end
  end

  # before action
  def set_me
    if api_user_signed_in?
      @me = 'user'
      @id = current_api_user.id
      @user_id = current_api_user.id
    elsif api_host_signed_in?
      @me = 'host'
      @id = current_api_host.id
      @user_id = params[:user_id]
    else
      render body: nil, status: :unauthorized
    end
  end

  private

  def agreement_user_signed_in_params
    params.permit(:host_id, :room_id).merge(state: 'before', user_id: current_api_user.id,
                                            start_time: Time.zone.parse(params[:start_time]),
                                            finish_time: Time.zone.parse(params[:finish_time]))
  end

  def agreement_host_signed_in_params
    params.permit(:user_id, :room_id).merge(state: 'before', host_id: current_api_host.id,
                                            start_time: Time.zone.parse(params[:start_time]),
                                            finish_time: Time.zone.parse(params[:finish_time]))
  end

  def cancell_comment_params
    params.permit(:comment).merge(agreement_id: params[:id])
  end
end
