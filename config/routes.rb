Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'static_pages#index'
  resources :books, only: [:new, :create, :show, :index]
  namespace :librarian do
    resources :libraries do
      resources :copies
    end
  end
end
