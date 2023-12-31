Rails.application.routes.draw do

  resources :articles do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create, :destroy]  
    end

    member do
      post :flag

      # Pinning
      post :pin
      post :unpin
    end  
  end

  resources :companies, path: 'c' do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create, :destroy]  
    end


    member do
      post :pin
      post :unpin
    end
  end

  resources :listings do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create, :destroy]  
    end

    member do
      post :flag
      post :pin
      post :unpin
    end
  end

  resources :jobs do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create, :destroy]  
    end

    member do
      post :flag

      # Pinning
      post :pin
      post :unpin
    end  
  end

  resources :comments, only: [] do  
    resources :replies, only: [:create, :destroy], as: 'replies' do
      member do
        post :flag
      end
    end
    
    member do
      post :flag
    end
  end


  # User Poasts

  resources :poasts do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create, :destroy]  
    end

    member do
      post :flag
      post :pin
      delete :unpin
    end
  end

  # Direct Messages
  
  resources :conversations, only: [:index, :new, :show, :create] do
    resources :messages, only: [:create]
  end

  # config/routes.rb
  post 'start_conversation/:recipient_id', to: 'conversations#start_conversation', as: 'start_conversation'



  # Notifications 
  resources :notifications, only: [:index] do
    member do
      post :mark_as_read
    end
    collection do
      post :mark_all_as_read
    end
  end

  # Following/Followers
  resources :relationships, only: [:create, :destroy]


  # Timeline

  get '/timeline', to: 'timelines#show', as: :timeline

  #resources :timelines, only: [:show]

  # Moderator Dashboard
  resources :moderators, only: [:index] do
    collection do
      post :hide_item, as: 'hide_item'
      post :unflag_item, as: 'unflag_item'
      post :lock_user
      post :unlock_user

      # Find and assign/remove badges to users
      post :assign_badge  
      delete :remove_badge 
      get :search_user, as: 'search_user'

      # Create new types of badges
      get :new_badge, as: 'new_badge'
      post :create_badge, as: 'create_badge'

      # Create global alert messages
      get :new_alert
      post :create_alert
      post :remove_alert
    end
  end
  
  # Admin Dashboard
  namespace :admin do
    root to: 'admin#index'  
    resources :advertisers, only: [:index, :new, :create, :edit, :update, :destroy] do
      resources :campaigns, only: [:index, :new, :create, :edit, :update, :destroy] do
        resources :adverts, only: [:index, :new, :create, :edit, :update, :destroy]
      end
    end
  end
  
  # for user IP storage, custom sessions & reg controller
devise_for :users, controllers: {
  sessions: 'users/sessions',
  registrations: 'users/registrations'
}
  resources :users, only: [:show] do
    resources :poasts, only: [:index]
    
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create, :destroy]  
    end

    member do
      
      get 'comments'
      get 'listings'
      get 'articles'
      
      get 'edit_bio'
      patch 'update_bio'
      
      post 'flag'
      post 'lock'  

      get 'followers'
      get 'following'

      
    end
  end


  # Search users
  get 'search_users', to: 'users#search'



  # Landing page
  root 'home#index'

  get '/marketplace', to: 'listings#index', as: 'marketplace'
  get '/privacy-policy', to: 'home#privacy_policy'
  get '/terms-of-service', to: 'home#terms_of_service'
  get '/new-user-guide', to: 'home#new_user_guide'
  
  
end
