Rbkapps::Application.routes.draw do
  root :to => 'main#index'

  scope "api" do
    resources :users
    resources :sessions
    resources :purchase_requests
    resources :purchase_request_lines
    resources :teams
    resources :items do
      collection { post :import }
    end
    resources :deliveries
    resources :invoices
    resources :form_helpers
    resources :deliveries_items
    resources :invoice_items
    resources :notes
    resources :suppliers
    resources :quotations
    resources :categories
    resources :service_requests
  end

  resources :comex_reports
  resources :application_reports

  root to: 'main#index'
  match '*path', to: 'main#index'
end
