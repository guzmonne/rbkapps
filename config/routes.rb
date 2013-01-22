Rbkapps::Application.routes.draw do

  root :to => 'main#index'
  scope "api" do
    resources :users
    resources :sessions
  end

  match '*path', to: 'main#index'
end
