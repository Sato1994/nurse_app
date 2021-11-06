class Api::UsersController < ApplicationController
include Pagination

  def index
    name = params[:name]
    address = params[:address]
    users = Kaminari.paginate_array(User.where('name LIKE ? && address LIKE ?', "%#{name}%", "%#{address}%")).page(params[:page]).per(10)
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
    @user = User.find_by!(myid: params[:id])
    if api_user_signed_in?
      if @user = current_api_user
        @requests = @user.user_requests
        @offers = @user.host_requests
        @agreements = @user.agreements
        @rooms = @user.rooms
      end
    end
    @skills = @user.skills
    @free_times = @user.free_times
    render "show", formats: :json, handlers: :jbuilder
  end
end
