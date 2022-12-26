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
        post '/hide_avatar_dialog' => 'dashboard#hide_avatar_dialog'
        post '/update_avatar' => 'users#update_avatar'
        post '/user_exists' => 'users#user_exists'
        post '/email_exists' => 'users#email_exists'

        get '/posts' => 'dashboard#fetch_posts'
        post '/posts' => 'dashboard#create_post'

        get '/tags/:tag' => 'dashboard#fetch_posts_by_tag'

        get '/search_gifs' => 'dashboard#search_gifs'
        post '/posts/:id/images' => 'dashboard#upload_images'

        post '/posts/:id/likes' => 'dashboard#update_post_likes'

        get '/profile/:username' => 'users#get_user_posts'
        get '/user/:username' => 'users#get_user'
        post '/profile' => 'users#save_details'
        post '/profile/banner' => 'users#save_banner'

        post '/user/:username/follow' => 'users#follow_user'
        delete '/user/:username/follow' => 'users#unfollow_user'

        get '/search_users' => 'users#search_users'
        get '/search' => 'dashboard#search_posts'

        post '/replies' => 'replies#create'
        get '/posts/:id' => 'posts#index'

        post '/replies/:id/likes' => 'replies#update_reply_likes'
        get '/replies/:id' => 'replies#index'
      end
    end
  end

end
