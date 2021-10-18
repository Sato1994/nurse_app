Rails.application.routes.draw do
  namespace :api do
    resources :users, except: :destroy
    mount_devise_token_auth_for 'User', at: 'user', controllers: {
      registrations: 'api/user/registrations'
    }
  end
  namespace :api do
    resources :hosts, except: :destroy
    mount_devise_token_auth_for 'Host', at: 'host', controllers: { 
      registrations: 'api/host/registrations'
    }
  end

  namespace :api do
    resources :skills do
      #shallow: trueでidを必要としないアクションだけをネスト外に書いたのと同じことにできる。
      resources :user_skills, only: [:create, :destroy], shallow: true
      resources :host_skills, only: [:create, :destroy], shallow: true
    end

  end
  namespace :api do
    resources :agreements, only: [:index, :show, :update, :destroy]
  end

  post 'api/agreements/user/:user_id', to: 'api/agreements#create'
  post 'api/agreements/host/:host_id', to: 'api/agreements#create'





  post 'api/free_times', to: 'api/free_times#create'


  post 'api/recruitment_times', to: 'api/recruitment_times#create'

  post 'api/host_requests/:user_id', to: 'api/host_requests#create'

  post 'api/user_requests/:host_id', to: 'api/user_requests#create'




end