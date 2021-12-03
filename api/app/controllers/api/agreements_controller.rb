class Api::AgreementsController < ApplicationController

  def index
    # 1.存在する自分が関与するAgreementsを取得
    # 3.そのうちstateが2～4のものは配列から除外する
    # 4.そのうちstateが0のものは勤務時間であればにstateを1に変更。
    # 5.そのうちstateが0か1のもののうち勤務時間を超えていれば2へ変更
    if api_user_signed_in?
      Agreement.where('user_id = ? && start_time <= ? && ? <= finish_time && state = 0', current_api_user.id, Time.current, Time.current).update_all(state: 1)
      Agreement.where('user_id = ? && finish_time < ? && (state = 0 || 1)', current_api_user.id, Time.current).update_all(state: 2)
      @agreements =Agreement.where('user_id = ?', current_api_user.id)

    elsif api_host_signed_in?
      Agreement.where('host_id = ? && start_time <= ? && ? <= finish_time && state = 0', current_api_host.id, Time.current, Time.current).update_all(state: 1)
      Agreement.where('host_id = ? && finish_time < ? && (state = 0 || 1)', current_api_host.id, Time.current).update_all(state: 2)
      @agreements =Agreement.where('host_id = ?', current_api_host.id)
    else
      render body: nil, status: 401
      return
    end
    render "index", formats: :json, handlers: :jbuilder
  end

  ########## agreement登録または時間の変更 ##########
  def create
    room = Room.find(params[:room_id])
    ### agreementが未だ作られていない場合
    if room.agreement.nil?
      if api_user_signed_in?
        agreement = Agreement.new(agreement_user_signed_in_params)
        if agreement.save
          FreeTime.destroy_free_times( current_api_user.id, Time.zone.parse(params[:start_time]), Time.zone.parse(params[:finish_time]))
          render json: agreement, status: 201
        else
          render json: agreement.errors, status: 400
        end
      elsif api_host_signed_in?
        agreement = Agreement.new(agreement_host_signed_in_params)
        if agreement.save
          FreeTime.destroy_free_times(params[:user_id], Time.zone.parse(params[:start_time]), Time.zone.parse(params[:finish_time]))
          render json: agreement, status: 201
        else
          render json: agreement.errors, status: 400
        end
      else
        render body: nil, status: 401
      end
    ### agreementが既に存在した場合
    else
      if api_user_signed_in?
        if room.agreement.update(agreement_user_signed_in_params)
          FreeTime.destroy_free_times( current_api_user.id, Time.zone.parse(params[:start_time]), Time.zone.parse(params[:finish_time]))
          render json: room.agreement, status: 200
        else
          render json: room.agreement.errors, status: 400
        end
      elsif api_host_signed_in?
        if room.agreement.update(agreement_host_signed_in_params)
          FreeTime.destroy_free_times(params[:user_id], Time.zone.parse(params[:start_time]), Time.zone.parse(params[:finish_time]))
          render json: room.agreement, status: 200
        else
          render json: room.agreement.errors, status: 400
        end
      else
        render body: nil, status: 401
      end
    end
  end

  ########## agreementの変更申請 ##########
  def update
    agreement = Agreement.find(params[:id])
    room = agreement.room
    if (api_user_signed_in? && current_api_user = agreement.user) || (api_host_signed_in? && current_api_host = agreement.host)
      if agreement.start_time > 24.hours.since
        result = agreement.update_state_consensus
        if result
          render json: result, status: 200
        else
          render body: nil, status: 500
        end
      else
        render body: nil, status: 400
      end
    else
      render body: nil, status: 403
    end
  end

  ########## agreementキャンセル ##########
  def cancell
    agreement = Agreement.find(params[:id])
    room = agreement.room
    if api_user_signed_in? && current_api_user === agreement.user
      agreement.cancell_agreement
    end
  end

  private

  def agreement_user_signed_in_params
    params.permit(:host_id, :room_id).merge(state: "before", user_id: current_api_user.id, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end

  def agreement_host_signed_in_params
    params.permit(:user_id, :room_id).merge(state: "before", host_id: current_api_host.id, start_time: Time.zone.parse(params[:start_time]), finish_time: Time.zone.parse(params[:finish_time]))
  end
end
