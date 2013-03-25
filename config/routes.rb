Rbkapps::Application.routes.draw do
  root :to => 'main#index'

  scope "api" do
    resources :users
    resources :sessions
    resources :purchase_requests
    resources :purchase_request_lines
    resources :teams
    resources :items
    resources :deliveries
    resources :invoices
    resources :form_helpers
    resources :deliveries_items
    resources :invoice_items
    resources :notes
  end

  match '*path', to: 'main#index'
end
