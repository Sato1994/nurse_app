# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    mount_devise_token_auth_for 'User', at: 'user', controllers: {
      registrations: 'api/user/registrations'
    }
    mount_devise_token_auth_for 'Host', at: 'host', controllers: {
      registrations: 'api/host/registrations'
    }

    scope module: :user do
      resources :users, only: %i[index show] do
        get 'history', on: :member
      end

      resources :user_notices, only: %i[index destroy]
      resources :user_messages, only: %i[create]
      resources :user_skills, only: %i[create destroy]
    end

    scope module: :host do
      resources :hosts, only: %i[index show] do
        get 'history', on: :member
      end

      resources :host_notices, only: %i[index destroy]
      resources :host_messages, only: %i[create]
      resources :host_skills, only: %i[create destroy]
    end

    scope module: :issue do
      resources :agreements, only: %i[update create] do
        get 'in_progress', on: :collection
        patch 'cancell', on: :collection
      end
      resources :rooms, only: %i[show update create] do
        patch 'cancell_room', on: :collection
        patch 'leave', on: :collection
        patch 'update_room_time', on: :collection
        patch 'update_room_state', on: :collection
      end

      resources :free_times, only: %i[index create destroy]
      resources :recruitment_times, only: %i[index create destroy]
      resources :user_requests, only: %i[index create destroy]
      resources :host_requests, only: %i[index create destroy]
    end

    resources :health_checks, only: :index
    resources :rates, only: [:create, :show]
    resources :skills, only: %i[index] do
    end
  end
end
