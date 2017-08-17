Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      namespace :invoices do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
        get 'random', to: 'random#show'
      end

      namespace :items do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
        get 'random', to: 'random#show'
      end

      namespace :invoice_items do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
        get 'random', to: 'random#show'
      end

      namespace :merchants do
         get '/find', to: 'find#show'
         get '/find_all', to: 'find#index'
         get '/random', to: 'random#show'
       end

      namespace :customers do
         get '/find', to: 'find#show'
         get '/find_all', to: 'find#index'
         get '/random', to: 'random#show'
         get '/:customer_id/favorite_merchant', to: 'favorite_merchant#show'
       end

      namespace :transactions do
         get '/find', to: 'find#show'
         get '/find_all', to: 'find#index'
         get '/random', to: 'random#show'
       end

       resources :merchants, only: [:index, :show] do
         resources :items, only: [:index, :show]
       end
       resources :transactions, only: [:index, :show]
       resources :customers, only: [:index, :show]
       resources :items, only: [:index, :show] do
         get "/invoice_items", to: "invoice_items#index", as: 'my_invoiceitems'
         get "/merchant", to: "merchants#show", as: 'my_merchant'
       end
       resources :invoice_items, only: [:index, :show] do
         get "/invoice", to: "invoices#show", as: 'my_invoice'
         get "/item", to: "items#show", as: 'my_item'
       end
       resources :invoices, only: [:index, :show] do
         resources :items, only: [:index], as: 'my_items'
         resources :transactions, only: [:index], as: 'my_transactions'
         resources :invoice_items, only: [:index], as: 'my_invoiceitems'
         get "/customer", to: "customers#show", as: 'my_customer'
         get "/merchant", to: "merchants#show", as: 'my_merchant'
      end
     end
   end
end
