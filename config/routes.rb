require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'pages#home'

  get 'auth/:provider/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
  get 'auth_logout' => 'auth0#destroy'

  devise_for :users, controllers: { sessions: 'users/sessions' }

  get 'account' => 'account#show'

  namespace :api do
    namespace :v1 do
      jsonapi_resources :memberships, only: %i[create destroy]
      jsonapi_resources :plans, only: %i[index show]
      jsonapi_resources :tags
      jsonapi_resources :tag_types
      jsonapi_resources :time_ranges, only: %i[index show create]
      jsonapi_resources :users
      jsonapi_resources :user_groups
    end
  end

  # Swagger documentation.
  mount Rswag::Ui::Engine => 'api_docs'
  mount Rswag::Api::Engine => 'api_docs'

  constraints ->(request) { request.session[:user_id].present? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  resources :pages, only: [:home], controller: 'pages' do
    get :home, on: :collection
  end

  resource :dashboard, only: :show, controller: 'dashboard'

  resources :teams, only: %i[dashboard individuals plans] do
    get :dashboard, on: :member
    get :plans, on: :member
    resources :individuals, only: :show, controller: 'team_individuals' do
      get :data, on: :member
    end
    get :individuals, on: :member
  end

  namespace :admin do
    resource :dashboard, only: :show, controller: 'dashboard'
    resources :group_types, except: :show do
      resources :user_groups, except: :show, shallow: true
    end
    resources :tag_types, except: :show do
      resources :tags, except: :show, shallow: true
    end
    resources :time_ranges, except: :show
    resources :users, except: :show
    resources :plans, only: :index
  end

  resources :notes, except: :show
  resources :plans, except: :show

  resources :signoffs, only: %i[sign revoke] do
    put :sign, on: :member
    put :revoke, on: :member
  end
end
