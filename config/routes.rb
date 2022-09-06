Rails.application.routes.draw do
  use_doorkeeper
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      namespace :auth do
        post '/register' => 'auth#register'
      end
      namespace :users do
        use_doorkeeper

        devise_for :users, controllers: {
          confirmations: 'api/v1/users/confirmations'
        }

        get ':id/confirmations/status' => 'users#confirmation_status'

        get '/dashboard' => 'dashboard#dashboard'
      end

      namespace :account do
        use_doorkeeper
      end
    end
  end

end
