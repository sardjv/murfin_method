require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'pages#home'

  get 'auth/:provider/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
  get 'auth_logout' => 'auth0#destroy'

  resources :notes

  namespace :api do
    namespace :v1 do
      jsonapi_resources :users
    end
  end

  # Swagger documentation.
  mount Rswag::Ui::Engine => 'api_docs'
  mount Rswag::Api::Engine => 'api_docs'

  constraints ->(request) { request.session[:userinfo].present? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :pages, only: [:home], controller: 'pages' do
    get :home, on: :collection
  end
  resource :dashboard, only: %i[teams individuals], controller: 'dashboard' do
    get :user, on: :collection
    get :admin, on: :collection
    get :teams, on: :collection
    get :individuals, on: :collection
  end
end
