Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :invoices do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
      end

      namespace :items do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
      end

      namespace :invoice_items do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
      end

      resources :items, only: [:index, :show]
      resources :invoice_items, only: [:index, :show]
      resources :invoices, only: [:index, :show]
    end
  end
end
