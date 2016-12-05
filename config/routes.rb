Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new', as: :new_user_session
    get 'sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end

  get 'transactions/new'

  # Administrate
  namespace :admin do
    resources :balances
    resources :goals
    resources :transactions
    resources :activities
    resources :users

    root to: "balances#index"
  end

  get :kudo_guidelines, to: 'transactions#kudo_guidelines'

  resources :transactions,
    only: [:new, :create] do
      get :guidelines, on: :collection

  end

  resources :users, only: [] do
    get :autocomplete_user_name, on: :collection
  end

  resources :activities, only: [] do
    get :autocomplete_activity_name, on: :collection

  end

  post 'like/:id', to: "transactions#upvote", as: :like

  resources :goals do
    get :pollvote
    post 'poll-like/:id', to: "goal#pollvote", as: :polllike
  end
  root 'dashboard#index'
end


