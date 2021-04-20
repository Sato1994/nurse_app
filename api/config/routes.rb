Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'user', controllers: {
      registrations: 'api/user/registrations'
    }
  end
  namespace :api do
    mount_devise_token_auth_for 'Host', at: 'host', controllers: { 
      registrations: 'api/host/registrations'
    }
  end
end



