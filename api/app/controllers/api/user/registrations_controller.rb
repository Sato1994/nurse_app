class Api::User::RegistrationsController <  DeviseTokenAuth::RegistrationsController

  private
    def sign_up_params
      params.permit(:name, :email, :address, :wanted, :sex, :age, :year, :password, :password_confirmation)
    end

    def account_update_params
      params.permit(:name, :email, :address, :image, :wanted, :sex, :age, :year, :profile, :password, :password_confirmation)
    end

end
