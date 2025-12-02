# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_scope :user do
    get '/users', to: redirect('/users/sign_up')
  end
  #トップページ
  root 'top_pages#index'

  # テンプレート一覧・デザイン選択用
  resources :templates, only: [:index] do
    #urlにidが必要ないためcollectionを使用
    collection do
      get :select   # /templates/select → デザイン選択ページ
    end
  end

  resources :letters, only: [:new, :create, :show, :index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check
  # Defines the root path route ("/")
  # root "posts#index"
end
