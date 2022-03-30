# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'user', controllers: {
      registrations: 'api/user/registrations'
    }
    mount_devise_token_auth_for 'Host', at: 'host', controllers: {
      registrations: 'api/host/registrations'
    }

    resources :users, except: :destroy
    resources :hosts, except: :destroy
    resources :free_times, only: %i[create destroy]
    resources :recruitment_times, only: %i[create destroy]
    resources :health_checks, only: :index
    resources :user_requests, only: [:destroy]
    resources :host_requests, only: [:destroy]
    resources :rates, only: [:create]

    resources :skills do
      resources :user_skills, only: %i[create destroy], shallow: true
      resources :host_skills, only: %i[create destroy], shallow: true
    end

    resources :agreements, only: %i[index show update destroy] do
      patch 'cancell', on: :collection
    end

    resources :rooms, only: %i[show update] do
      patch 'cancell_room', on: :collection
    end
  end
  post 'api/agreements/user/:user_id', to: 'api/agreements#create'
  post 'api/agreements/host/:host_id', to: 'api/agreements#create'

  post 'api/host_requests/:free_time_id', to: 'api/host_requests#create'
  post 'api/user_requests/:recruitment_time_id', to: 'api/user_requests#create'

  delete 'api/user_requests', to: 'api/user_requests#destroy'
  delete 'api/host_requests', to: 'api/host_requests#destroy'

  post 'api/rooms', to: 'api/rooms#create'
  patch 'api/rooms/:id/update_room_time', to: 'api/rooms#update_room_time'
  patch 'api/rooms/:id/update_room_state', to: 'api/rooms#update_room_state'

  post 'api/user_messages/:room_id', to: 'api/user_messages#create'

  post 'api/host_messages/:room_id', to: 'api/host_messages#create'
end
