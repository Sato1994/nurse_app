# frozen_string_literal: true

class Api::Host::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def update
    if @resource
      if params[:address]
        @lat = 35.658581
        @lng = 139.745433
        if @resource.send(resource_update_method, account_update_params_with_address)
          yield @resource if block_given?
          render_update_success
        else
          render_update_error
        end
      elsif @resource.send(resource_update_method, account_update_params)
        yield @resource if block_given?
        render_update_success
      else
        render_update_error
      end
    else
      render_update_error_user_not_found
    end
  end

  private

  def sign_up_params
    params.permit(:name, :email, :wanted, :profile, :myid, :phone, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:name, :email, :image, :address,  :wanted, :profile, :myid, :phone, :password,
                  :password_confirmation)
  end

  def account_update_params_with_address
    params.permit(:name, :email, :image, :address, :wanted, :profile, :myid, :phone, :password,
                  :password_confirmation).merge(lat: @lat, lng: @lng)
  end
end
