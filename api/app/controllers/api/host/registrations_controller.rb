# frozen_string_literal: true

class Api::Host::RegistrationsController < DeviseTokenAuth::RegistrationsController
  private

  def sign_up_params
    params.permit(:name, :email, :address, :wanted, :profile, :myid, :phone, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:name, :email, :image, :address, :wanted, :profile, :myid, :phone, :password, :password_confirmation)
  end
end
