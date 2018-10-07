# frozen_string_literal: true

Rails.application.routes.draw do
  resources :memberships
  resources :beer_clubs
  resources :users
  resources :beers
  resources :breweries
  resource :session, only: [:new, :create, :destroy]
  resources :places, only: [:index, :show]
  post 'places', to:'places#search'
  root 'breweries#index'
  get 'signup', to: 'users#new'
  get 'signin', to: 'sessions#new'
  delete 'signout', to: 'sessions#destroy'
  get 'places', to: 'places#index'
  post 'places', to:'places#search'
  get 'styles', to: 'styles#index'
  resources :styles, only: [:index, :show]
  # get 'kaikki_bisset', to: 'beers#index'
  # get 'ratings', to: 'ratings#index'
  # get 'ratings/new', to:'ratings#new'
  # post 'ratings', to: 'ratings#create'
  resources :ratings, only: %i[index new create destroy]
  resources :memberships, only: %i[index new create destroy]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
