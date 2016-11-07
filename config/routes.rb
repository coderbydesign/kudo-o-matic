Rails.application.routes.draw do

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


