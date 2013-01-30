Rbkapps::Application.routes.draw do

  root :to => 'main#index'
  scope "api" do
    resources :users
    resources :sessions
    resources :purchase_requests
    resources :purchase_request_lines
    resources :teams
  end

  match '*path', to: 'main#index'
end
