Rails.application.routes.draw do
  resources :companies

  devise_for :users
  root 'home#index'

  get 'marketplace', to: 'home#marketplace'
  get '/privacy-policy', to: 'home#privacy_policy'
  get '/terms-of-service', to: 'home#terms_of_service'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
