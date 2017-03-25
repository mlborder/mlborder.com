Rails.application.routes.draw do
  root 'static_pages#home'

  get 'about', to: 'static_pages#about'

  get 'enjoy_harmony', to: redirect('/events/75'), status: :moved_permanently
  get 'events/latest', to: 'events#show'
  resources :events, except: [:destroy] do
    get 'default_series_name', on: :member, constraints: -> (req) { req.xhr? }

    resources :records, module: :events, only: :index
    resources :borders, module: :events, only: :index, constraints: -> (req) { req.xhr? } do
      post 'recent', on: :collection
    end
  end
  resources :dramacd_themes, only: [:index]
  resources :idols, only: [:index, :show]
  resources :weeks, module: :weeks, only: [] do
    resources :idol_records, only: :index
    resources :player_records, only: :index
  end

  resources :users, expect: %i(new create destroy) do
    resources :alarms, module: :users, except: [:new, :edit]
  end
  resources :players, module: :players, only: [] do
    resources :records, only: :index
  end

  get 'alarm', to: 'static_pages#alarm'

  resources :records, only: :index do
    get 'search', on: :collection
  end

  scope '/misc' do
    get 'runners', to: 'misc#runners'
    get 'bmd_runner', to: redirect('/misc/runners?event=bmd')
  end

  get '/auth/:provider/callback', to: 'sessions#callback'
  post '/auth/:provider/callback', to: 'sessions#callback'
  get '/logout' => 'sessions#destroy', as: :logout
end
