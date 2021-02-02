Rails.application.routes.draw do
  root to: "dashboard#index"

  devise_for :users

  resources :outgoing_trusts, only: %i[new create show], path: :outgoing do
    resources :academies, only: %i[index create]
    resource :identify, only: %i[show create], controller: :identify
    resources :incoming_trusts, only: %i[index create destroy], path: :incoming do
      get :search, on: :collection
    end
    resources :projects, only: %i[new create]
  end

  resources :trusts, only: [:index]
  resources :projects, only: %i[index show]

  get "/pages/:page", to: "pages#show"

  get "/404", to: "errors#not_found", via: :all
  get "/422", to: "errors#unprocessable_entity", via: :all
  get "/500", to: "errors#internal_server_error", via: :all
end
