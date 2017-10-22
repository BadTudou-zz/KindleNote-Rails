Rails.application.routes.draw do
  get 'sessions/new'

    get 'register',         to: 'users#new'
    post 'register',        to: 'users#create'
    get  '/login',          to: 'sessions#new'
    post   '/login',        to: 'sessions#create'
    delete '/logout',       to: 'sessions#destroy'

    
    scope 'evernote' do
      get 'authorize',     to: 'evernote#authorize'
      get 'callback',      to: 'evernote#callback'
      get '/',          to: 'evernote#user'
      post '/:id',             to: 'evernote#store', as: 'evernote_store'
    end

    resources :users do
      resources :clippings
      resources :notes do
        get 'markdown',  to: 'notes#markdown', as: 'markdown'
        resources :fragments
      end
    end
   
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
