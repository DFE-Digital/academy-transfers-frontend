Rails.application.routes.draw do
  root to: "trusts#index"

  devise_for :users

  resources :trusts, only: %i[index show] do
    get :search, on: :collection
    resources :academies, only: %i[index create]
    resources :incoming_trusts, only: %i[index show], path: :incoming do
      get :search, on: :collection
    end
  end

  get "/pages/:page", to: "pages#show"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
