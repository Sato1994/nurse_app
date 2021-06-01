Rails.application.routes.draw do
  namespace :api do
    resources :users
    mount_devise_token_auth_for 'User', at: 'user', controllers: {
      registrations: 'api/user/registrations'
    }
  end
  namespace :api do
    resources :hosts
    mount_devise_token_auth_for 'Host', at: 'host', controllers: { 
      registrations: 'api/host/registrations'
    }
  end

  namespace :api do
    resources :skills do
      #shallow: trueでidを必要としないアクションだけをネスト外に書いたのと同じことにできる。
      resources :user_skills, only: [:create, :destroy], shallow: true
    end

  end

end