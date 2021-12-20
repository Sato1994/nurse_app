class Api::UsersController < ApplicationController
include Pagination

  def index
    lower_year = params[:lowerYear]
    address = params[:address]
    users = Kaminari.paginate_array(User.where('year >= ? && address LIKE ?', lower_year, "%#{address}%")).page(params[:page]).per(10)
    @pagination = resources_with_pagination(users)
    @users = users.as_json
    @object = {
      users: @users, kaminari: @pagination
    }
    render json: @object
  end

  def show
    # !で、レコードが見つからない場合nilでなくて404を発生させられる。
    # 個人のページのURLをmyidにする。
    if api_user_signed_in? && current_api_user.myid = params[:id]
      @user = current_api_user
      @requests = current_api_user.user_requests
      @offers = current_api_user.host_requests
      @agreements = current_api_user.agreements
      @rooms = current_api_user.rooms
      @skills = current_api_user.skills
      @free_times = current_api_user.free_times
    else
      @user = User.find_by!(myid: params[:id])
      @free_times = @user.free_times
      @skills = @user.skills
    end
    render "show", formats: :json, handlers: :jbuilder
  end
end
