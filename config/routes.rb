Rbkapps::Application.routes.draw do

  get "sessions/create"

  get "sessions/show"

  root :to => 'main#index'
  scope "api" do
    resources :users
  end
end
