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

  get :users, to: 'users#autocomplete_search', as: :users_autocomplete

  get :activities, to: 'activities#autocomplete_search', as: :activities_autocomplete

  post 'like/:id', to: "transactions#upvote", as: :like
  post 'unlike/:id', to: "transactions#downvote", as: :unlike

  resources :goals do
    get :pollvote
    post 'poll-like/:id', to: "goal#pollvote", as: :polllike
  end

  get '/transactions/:type' => 'transactions#filter'

  get '/transactions', to: 'transactions#index'

  get "minigames" => "minigames#index"
  get "minigames/kudosclicker" => "kudosclicker#index"
  get "/feed", to: "feed#index"

  root 'transactions#index'
end


