Rbkapps::Application.routes.draw do

  get "invoice_items/index"

  get "invoice_items/create"

  get "invoice_items/update"

  get "invoice_items/show"

  get "invoice_items/destroy"

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
  end

  match '*path', to: 'main#index'
end
