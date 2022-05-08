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

  def create
    build_resource

    if @resource.blank?
      raise DeviseTokenAuth::Errors::NoResourceDefinedError,
            "#{self.class.name} #build_resource does not define @resource,"\
            ' execution stopped.'
    end

    # give redirect value from params priority
    @redirect_url = params.fetch(
      :confirm_success_url,
      DeviseTokenAuth.default_confirm_success_url
    )

    # success redirect url is required
    return render_create_error_missing_confirm_success_url if confirmable_enabled? && !@redirect_url

    # if whitelist is set, validate redirect_url against whitelist
    return render_create_error_redirect_url_not_allowed if blacklisted_redirect_url?(@redirect_url)

    # override email confirmation, must be sent manually from ctrl
    callback_name = defined?(ActiveRecord) && resource_class < ActiveRecord::Base ? :commit : :create
    resource_class.set_callback(callback_name, :after, :send_on_create_confirmation_instructions)
    resource_class.skip_callback(callback_name, :after, :send_on_create_confirmation_instructions)

    if @resource.respond_to? :skip_confirmation_notification!
      # Fix duplicate e-mails by disabling Devise confirmation e-mail
      @resource.skip_confirmation_notification!
    end

    if @resource.save

      unless @resource.confirmed?
        # user will require email authentication
        @resource.send_confirmation_instructions({
                                                   client_config: params[:config_name],
                                                   redirect_url: @redirect_url
                                                 })
      end

      if active_for_authentication?
        # email auth has been bypassed, authenticate user
        @token = @resource.create_token
        @resource.save!
        update_auth_header
      end

      render_host = {
        id: @resource.id, myid: @resource.myid, name: @resource.name, address: @resource.address, lat: @resource.lat, lng: @resource.lng,
        image: @resource.image, wanted: @resource.wanted, phone: @resource.phone, profile: @resource.profile,
        created_at: @resource.created_at, rate_count: @resource.rates.count, rate_average: @resource.star_average
      }

      render json: {
        info: render_host
      }

    else
      clean_up_passwords @resource
      render_create_error
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
