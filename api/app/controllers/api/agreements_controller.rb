class Api::AgreementsController < ApplicationController

  def index
    @agreements = Agreement.all
    render "index", formats: :json, handlers: :jbuilder
  end

  def create
    if api_user_signed_in?
      @host = Host.find(params[:host_id])
      agreement = Agreement.new(agreement_user_signed_in_params)
      if agreement.save
        render json: agreement, status: 201
      else
        render json: agreement.errors, status: 400
      end
    elsif api_host_signed_in?
      @user = User.find(params[:user_id])
      agreement = Agreement.new(agreement_host_signed_in_params)
      if agreement.save
        render json: agreement, status: 201
      else
        render json: agreement.errors, status: 400
      end
    else
      render body: :nil, status: 400
    end

  end

  def show
    agreement = Agreement.find(params[:id])
    render json: agreement, status: 200
  end

  def update
    agreement = Agreement.find(params[:id])
    if api_user_signed_in?
      @host = agreement.host
      if agreement.update(agreement_user_signed_in_params)
        render json: agreement, status: 200
      else
        render json: agreement.errors, status: 400
      end
    elsif api_host_signed_in?
      @user = agreement.user
      if agreement.update(agreement_host_signed_in_params)
        render json: agreement, status: 200
      else
        render json: agreement.errors, status: 400
      end
    end
  end

  def destroy
    agreement = Agreement.find(params[:id])
    if agreement.destroy
      render body: nil, status: 204
    else
      render json: agreement.errors, status: 400
    end
  end

  private


  # def agreement_params
  #   params.require(:agreement).permit(:start_time, :finish_time, :states).merge(user: current_api_user, host: @host)
  # end

  def agreement_user_signed_in_params
    params.require(:agreement).permit(:state).merge(user: current_api_user, host: @host, start_time: Time.current, finish_time: Time.current)
  end

  def agreement_host_signed_in_params
    params.require(:agreement).permit(:state).merge(user: @user, host: current_api_host, start_time: Time.current, finish_time: Time.current)
  end






end
