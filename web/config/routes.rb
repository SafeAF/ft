Rails.application.routes.draw do

  resources :articles do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create]  
    end

    member do
      post :flag
    end  
  end

  resources :companies do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create]  
    end
  end

  resources :listings do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create]  
    end

    member do
      post :flag
    end
  end

  resources :jobs do
    resources :comments, only: [:create, :edit, :update, :destroy] do
      resources :replies, only: [:create]  
    end

    member do
      post :flag
    end  
  end

  resources :comments, only: [] do  
    resources :replies, only: [:create], as: 'replies'
    member do
      post :flag
    end
  end

  resources :conversations, only: [:index, :new, :create] do
    resources :messages, only: [:index, :create]
  end
  

  resources :moderators, only: [:index] do
    collection do
      post :hide_item, as: 'hide_item'
      post :unflag_item, as: 'unflag_item'
      post :lock_user
      post :unlock_user
    end
  end
  
  
  devise_for :users

  
  resources :users, only: [:show] do
    member do
      get 'comments'
      get 'listings'
      get 'articles'
      
      get 'edit_bio'
      patch 'update_bio'
      
      post 'flag'
      post 'lock'  
      
      get 'notifications'
      
    end
  end

  root 'home#index'

  get '/marketplace', to: 'listings#index', as: 'marketplace'
  get '/privacy-policy', to: 'home#privacy_policy'
  get '/terms-of-service', to: 'home#terms_of_service'
  get '/new-user-guide', to: 'home#new_user_guide'
  
  
end
