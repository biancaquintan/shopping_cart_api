# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  get 'up' => 'rails/health#show', as: :rails_health_check
  root 'rails/health#show'

  namespace :api do
    namespace :v1 do
      resource :carts, only: %i[create show] do
        post 'add_item', on: :collection
        delete ':product_id', to: 'carts#remove_item', on: :collection
      end

      resources :products
    end
  end
end
