Rails.application.routes.draw do
  resources :articles do
    resources :comments, only: [:create, :edit, :update, :destroy]

    member do
      post :flag
    end  
  end

  resources :companies do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  resources :listings do
    resources :comments, only: [:create, :edit, :update, :destroy] 
  
    member do
      post :flag
    end
  end

  resources :jobs do
    resources :comments, only: [:create, :edit, :update, :destroy] 

    member do
      post :flag
    end  
  end
  
  devise_for :users

  # config/routes.rb
  resources :users, only: [:show] do
    member do
      get 'comments'
      get 'listings'
      get 'articles'
      
      get 'edit_bio'
      patch 'update_bio'
      
    end
  end

  root 'home#index'

  get '/marketplace', to: 'listings#index', as: 'marketplace'
  get '/privacy-policy', to: 'home#privacy_policy'
  get '/terms-of-service', to: 'home#terms_of_service'
  get '/new-user-guide', to: 'home#new_user_guide'
  
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
