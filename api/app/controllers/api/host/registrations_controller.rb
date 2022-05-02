# frozen_string_literal: true

class Api::Host::RegistrationsController < DeviseTokenAuth::RegistrationsController
  def destroy
    unless @resource
      render_destroy_error
      return
    end

    if @resource.valid_agreements_exists? || @resource.valid_rooms_exists?
      render_message '有効な交渉、または契約が存在するため退会できません。', :bad_request
    else
      if @resource.soft_delete
        Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
        yield resource if block_given?
        render_destroy_success
      else
        render render_message
      end
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
end
