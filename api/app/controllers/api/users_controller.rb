class Api::UsersController < ApplicationController


  def index
    @users = User.all
    render "index", formats: :json, handlers: :jbuilder
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
      end
    end
    @skills = @user.skills
    @free_times = @user.free_times
    render "show", formats: :json, handlers: :jbuilder
  end
end
