Rails.application.routes.draw do
  use_doorkeeper
  root 'transactions#index'

  resources :transactions, only: [:index, :show, :create]

  post 'like/:id', to: 'transactions#upvote', as: :like
  post 'unlike/:id', to: 'transactions#downvote', as: :unlike

  get :kudo_guidelines, to: 'transactions#kudo_guidelines'
  get 'transactions/:type', to: 'transactions#filter'

  get :activities, to: 'activities#autocomplete_search', as: :activities_autocomplete
  get :users, to: 'users#autocomplete_search', as: :users_autocomplete

  get :settings, to: 'users#edit', as: :user
  patch :settings, to: 'users#update'

  get :feed, to: 'feed#index'

  get 'account/view_data', to: 'users#view_data', as: :users_view_data
  get 'account/view_data/transactions', to: 'users#view_transactions', as: :users_view_transactions
  get 'account/view_data/votes', to: 'users#view_votes', as: :users_view_votes
  get 'account/export', to: 'users#export', as: :users_export_data

  get 'legal/privacy'

  scope :slack, controller: :slack do
    post :action
    post :command
    post :reaction
  end

  namespace :admin do
    root 'users#index'

    resources :users, except: :destroy do
      member do
        patch :deactivate
        patch :reactivate
      end
    end

    resources :balances
    resources :goals
    resources :transactions
    resources :activities
    resources :votes
    resources :fcm_tokens
  end

  namespace :api do
    namespace :v1 do
      jsonapi_resources :balances, only: :show do
        collection do
          get :current
        end

        jsonapi_links :transactions, only: :show

        jsonapi_related_resources :transactions, only: :show
      end

      jsonapi_resources :goals, only: :show do
        collection do
          get :next
          get :previous
        end

        jsonapi_link :balance, only: :show

        jsonapi_related_resource :balance, only: :show
      end

      jsonapi_resources :transactions, only: [:index, :show, :create] do
        member do
          put :like, to: 'transactions#like'
          delete :like, to: 'transactions#unlike'
        end

        jsonapi_link :sender, only: :show
        jsonapi_link :receiver, only: :show
        jsonapi_link :balance, only: :show

        jsonapi_related_resource :sender, only: :show
        jsonapi_related_resource :receiver, only: :show
        jsonapi_related_resource :balance, only: :show
      end

      jsonapi_resources :users, only: [:index, :show] do
        jsonapi_links :sent_transactions, only: :show
        jsonapi_links :received_transactions, only: :show

        jsonapi_related_resources :sent_transactions, only: :show
        jsonapi_related_resources :received_transactions, only: :show
      end

      scope :statistics, controller: :statistics do
        get :general
        get :graph
        get :user
      end

      scope :authentication, controller: :authentication do
        post :obtain_api_token
        post :store_fcm_token
      end
    end
    namespace :v2 do
      jsonapi_resources :balances, only: :show do
        collection do
          get :current
        end

        jsonapi_links :transactions, only: :show

        jsonapi_related_resources :transactions, only: :show
      end

      jsonapi_resources :goals, only: :show do
        collection do
          get :next
          get :previous
        end

        jsonapi_link :balance, only: :show

        jsonapi_related_resource :balance, only: :show
      end

      jsonapi_resources :transactions, only: [:index, :show, :create] do
        member do
          put :like, to: 'transactions#like'
          delete :like, to: 'transactions#unlike'
        end

        jsonapi_link :sender, only: :show
        jsonapi_link :receiver, only: :show
        jsonapi_link :balance, only: :show

        jsonapi_related_resource :sender, only: :show
        jsonapi_related_resource :receiver, only: :show
        jsonapi_related_resource :balance, only: :show
      end

      jsonapi_resources :users, only: [:index, :show] do
        jsonapi_links :sent_transactions, only: :show
        jsonapi_links :received_transactions, only: :show

        jsonapi_related_resources :sent_transactions, only: :show
        jsonapi_related_resources :received_transactions, only: :show
      end

      scope :statistics, controller: :statistics do
        get :general
        get :graph
        get :user
      end

      scope :authentication, controller: :authentication do
        post :obtain_api_token
        post :store_fcm_token
      end
    end
  end

  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks',
    registrations: :registrations
  }

  devise_scope :user do
    get 'sign_in', to: 'devise/sessions#new'
    get 'sign_up', to: 'devise/registrations#new'
    get 'account', to: 'devise/registrations#edit'
    get 'sign_out', to: 'devise/sessions#destroy'
  end
end
