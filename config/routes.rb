Rails.application.routes.draw do
  root 'homes#top'
  get 'home/about' => 'homes#about'

  post "books/new" => "books#new"

  devise_for :users
  resources :books do
  	resource :favorites, only: [:create, :destroy]
  	resource :book_comments, only: [:create, :destroy]
  end
  
  resources :users,only: [:show,:index,:edit,:update] do
    member do
      get :followings, :followers
    end
  end
  resources :relationships, only: [:create, :destroy]
  
  get 'search' => 'search#search'
  
end