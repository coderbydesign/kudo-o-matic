Rails.application.routes.draw do
  root 'transactions#index'

  resources :transactions, only: [:index, :new, :create]

  post 'like/:id', to: 'transactions#upvote', as: :like
  post 'unlike/:id', to: 'transactions#downvote', as: :unlike

  get :kudo_guidelines, to: 'transactions#kudo_guidelines'
  get 'transactions/:type', to: 'transactions#filter'

  get :activities, to: 'activities#autocomplete_search', as: :activities_autocomplete
  get :users, to: 'users#autocomplete_search', as: :users_autocomplete

  get :feed, to: 'feed#index'

  namespace :admin do
    root 'balances#index'

    resources :balances
    resources :goals
    resources :transactions
    resources :activities
    resources :votes

    resources :users, except: :destroy do
      member do
        patch :deactivate
        patch :reactivate
      end
    end
  end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :balances do
        collection do
          get :current
        end
      end

      jsonapi_resources :goals do
        collection do
          get :next
          get :previous
        end
      end

      jsonapi_resources :transactions do
        member do
          put 'votes/:user_id', to: 'transactions#update_vote'
          delete 'votes/:user_id', to: 'transactions#destroy_vote'
        end
      end

      jsonapi_resources :activities
      jsonapi_resources :users
      jsonapi_resources :votes

      post 'authentication/obtain_api_token'
    end
  end

  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks'}

  devise_scope :user do
    get :sign_in, to: 'devise/sessions#new', as: :new_user_session
    get :sign_out, to: 'devise/sessions#destroy', as: :destroy_user_session
  end
end
