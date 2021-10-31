class Api::UsersController < ApplicationController


  def index
    @users = User.all
    render "index", formats: :json, handlers: :jbuilder
  end

  
  def show
    # !で、レコードが見つからない場合nilでなくて404を発生させられる。
    # 個人のページのURLをmyidにする。
    @user = User.find_by!(myid: params[:id])
    render "show", formats: :json, handlers: :jbuilder
  end
end
