Rails.application.routes.draw do
  resources :companies

  devise_for :users
  root 'home#index'

  get 'marketplace', to: 'home#marketplace'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
