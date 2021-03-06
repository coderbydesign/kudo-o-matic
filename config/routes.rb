# frozen_string_literal: true

Rails.application.routes.draw do
  use_doorkeeper
  root 'team_selector#index'

  resources :teams, only: %i[new create]

  get :kudo_guidelines, to: 'guidelines#kudo_guidelines'


  get :activities, to: 'activities#autocomplete_search', as: :activities_autocomplete

  post :resend_email_confirmation, to: 'users#resend_email_confirmation',
       as: :users_resend_email_confirmation

  get :feed, to: 'feed#index'

  get 'account/view_data', to: 'users#view_data', as: :users_view_data
  get 'account/view_data/transactions', to: 'users#view_transactions', as: :users_view_transactions
  get 'account/view_data/likes', to: 'users#view_likes', as: :users_view_likes
  post 'account/export/json', to: 'users#export_json', as: :users_export_json
  post 'account/export/xml', to: 'users#export_xml', as: :users_export_xml
  get 'account/export/download/:uuid', to: 'users#download_export', as: :users_download_export

  get 'legal/privacy'

  scope :hc, controller: :help do
    get 'getting-started', to: 'helpcenter#start'
    get 'contact', to: 'helpcenter#contact'
    get 'how-to-use', to: 'helpcenter#how_to_use'
    get 'profile-and-preferences', to: 'helpcenter#profile_and_preferences'
  end

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

    resources :guidelines
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

      jsonapi_resources :transactions, only: %i[index show create] do
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

      jsonapi_resources :users, only: %i[index show] do
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
      post 'fcm', to: 'authentication#store_fcm_token'

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

      jsonapi_resources :transactions, only: %i[index show create] do
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

      scope :users, controller: :users do
        get :me, to: 'users#me'
        get 'me/statistics', to: 'statistics#user'
      end

      scope :invites, controller: :team_invites do
        get :me, to: 'team_invites#me'
        put ':id', to: 'team_invites#update'
      end

      jsonapi_resources :users, only: %i[index show] do
        jsonapi_links :sent_transactions, only: :show
        jsonapi_links :received_transactions, only: :show

        jsonapi_related_resources :sent_transactions, only: :show
        jsonapi_related_resources :received_transactions, only: :show
      end

      scope :teams, controller: :teams do
        get :me, to: 'teams#me'
      end

      scope :statistics, controller: :statistics do
        get :general
        get :graph
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

  scope 'invites' do
    put 'accept/:id', to: 'team_invite#accept', as: :accept_invite
    put 'decline/:id', to: 'team_invite#decline', as: :decline_invite
  end

  scope ':team' do
    root to: 'transactions#index', as: 'dashboard'
    resources :transactions, param: :id
    get 'transactions/:type', to: 'transactions#filter'

    post 'like/:id', to: 'transactions#upvote', as: :like
    post 'unlike/:id', to: 'transactions#downvote', as: :unlike

    get :settings, to: 'users#index', as: :settings
    get 'settings/privacy', to: 'users#privacy', as: :privacy_settings
    patch :settings, to: 'users#update'

    scope 'manage' do
      get '/', to: 'teams#manage', as: :manage_team
      patch 'update', to: 'teams#update', as: :team_update
      get 'invites', to: 'team_invite#index', as: :manage_invites
      post 'invites', to: 'team_invite#create', as: :create_invites
      delete 'invites/:id', to: 'team_invite#delete', as: :delete_invites
      get 'members', to: 'team_member#index', as: :manage_team_members
      delete 'members', to: 'team_member#delete', as: :delete_member
      resources :balances, path: 'balances'
      resources :goals, path: 'goals'
      resources :guidelines, path: 'guidelines'
    end

    get :users, to: 'users#autocomplete_search', as: :users_autocomplete

    get 'omniauth/slack' => 'teams#slack', as: :team_omniauth
  end

  match '*path' => redirect('/'), via: :get
end
