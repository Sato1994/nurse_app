# frozen_string_literal: true

class Api::Host::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def update
    if @resource
      if @resource.send(resource_update_method, account_update_params)

        render_host = {
          id: @resource.id, myid: @resource.myid, name: @resource.name, address: @resource.address, lat: @resource.lat, lng: @resource.lng,
          image: @resource.image, wanted: @resource.wanted, phone: @resource.phone, profile: @resource.profile,
          created_at: @resource.created_at, rate_count: @resource.rates.count, rate_average: @resource.star_average
        }

        render json: {
          info: render_host
        }

      else
        render_update_error
      end
    else
      render_update_error_user_not_found
    end
  end

  def destroy
    unless @resource
      render_destroy_error
      return
    end

    if @resource.valid_agreements_exists? || @resource.valid_rooms_exists?
      render_message '有効な交渉、または契約が存在するため退会できません。', :bad_request
    elsif @resource.soft_delete
      Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
      render_destroy_success
    else
      render render_message
    end
  end

  private

  def sign_up_params
    params.permit(:name, :email, :address, :wanted, :profile, :myid, :phone, :password, :password_confirmation)
  end

  def account_update_params
    params.permit(:name, :email, :image, :address,  :wanted, :profile, :myid, :phone, :password,
                  :password_confirmation)
  end
end
