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
        get 'most_items', to: 'most_items#index'
        get '/:item_id/best_day', to: 'best_day#show'
        get 'most_revenue', to: 'revenue#index'
      end

      namespace :invoice_items do
        get 'find', to: 'find#show'
        get 'find_all', to: 'find#index'
        get 'random', to: 'random#show'
      end
      
      namespace :merchants do         get '/find', to: 'find#show'
         get '/find_all', to: 'find#index'
         get '/random', to: 'random#show'
         get '/:merchant_id/revenue', to: 'revenue#show'
         get 'most_items', to: 'most_items#index'
         get '/most_revenue', to: 'revenue#index'
         get '/find', to: 'find#show'
         get '/find_all', to: 'find#index'
         get '/random', to: 'random#show'
         get '/:id/favorite_customer', to: 'customers#show'
         get '/:id/revenue', to: 'revenue#show'
         get '/revenue', to: 'revenue_by_date#show'
         get '/:id/customers_with_pending_invoices', to: 'customers#index'
         get '/:id/items', to: 'items#index'
         get '/:id/invoices', to: 'invoices#index'
      end

      namespace :customers do
         get '/find', to: 'find#show'
         get '/find_all', to: 'find#index'
         get '/random', to: 'random#show'
         get '/:customer_id/favorite_merchant', to: 'favorite_merchant#show'
         get '/:id/invoices', to: 'invoices#index'
         get '/:id/transactions', to: 'transactions#index'
       end

      namespace :transactions do
        get '/find', to: 'find#show'
        get '/find_all', to: 'find#index'
        get '/random', to: 'random#show'
        get '/:id/invoice', to: 'invoice#show'
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
