require 'sidekiq/web'

Rails.application.routes.draw do
  root to: 'pages#home'

  get 'auth/:provider/callback' => 'auth0#callback'
  get 'auth/failure' => 'auth0#failure'
  get 'auth_logout' => 'auth0#destroy'

  constraints ->(request) { request.session[:userinfo].present? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
