Rails.application.routes.draw do
  # API routes
  namespace :api do
    namespace :v1 do
      resources :tasks, only: [:index, :show, :create, :update, :destroy]
      
      # Authentication routes
      namespace :auth do
        post 'login', to: 'auth#login'
      end
    end
  end

  # Swagger documentation
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  # Health check endpoint
  get '/health', to: 'health#index'

  # Root path
  root to: redirect('/api-docs')
end
