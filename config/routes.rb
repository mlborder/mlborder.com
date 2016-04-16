Rails.application.routes.draw do
  root 'static_pages#home'

  get 'about', to: 'static_pages#about'

  get 'enjoy_harmony', to: redirect('/events/75'), status: :moved_permanently
  get 'events/latest', to: 'events#show'
  resources :events, except: [:destroy] do
    get 'default_series_name', on: :member, constraints: -> (req) { req.xhr? }

    resources :records, module: :events, only: :index
    resources :borders, module: :events, only: :index, constraints: -> (req) { req.xhr? }
  end
  resources :idols, only: [:index, :show]
  resources :weeks, only: [] do
    resources :idol_records, module: :weeks, only: :index
  end

  resources :users, only: [:index] do
    resources :alarms, module: :users, except: [:new, :edit]
  end

  get 'alarm', to: 'static_pages#alarm'
  get 'records', to: 'records#index'

  get '/auth/:provider/callback', to: 'sessions#callback'
  post '/auth/:provider/callback', to: 'sessions#callback'
  get '/logout' => 'sessions#destroy', as: :logout

  namespace :api, module: :api, defaults: { format: :json } do
    get 'events/latest', to: 'events#show'
    resources :events, only: [:show]
  end
end
