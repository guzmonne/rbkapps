Rbkapps::Application.routes.draw do

  root :to => 'main#index'
  scope "api" do
    resources :users
    resources :sessions
  end
end
