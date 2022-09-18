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

        get '/user' => 'dashboard#user'
        post 'hide_avatar_dialog' => 'dashboard#hide_avatar_dialog'
        post 'update_avatar' => 'users#update_avatar'

        get '/posts' => 'dashboard#fetch_posts'
        post '/posts' => 'dashboard#create_post'
      end

      namespace :account do
        use_doorkeeper
      end
    end
  end

end
