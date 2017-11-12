Rails.application.routes.draw do
  get 'sessions/new'

    get 'register',         to: 'users#new'
    post 'register',        to: 'users#create'
    get  '/login',          to: 'sessions#new'
    post   '/login',        to: 'sessions#create'
    delete '/logout',       to: 'sessions#destroy'

    
    scope 'evernote' do
      get 'authorize',     to: 'evernote#authorize', as: 'evernote_authorize'
      get 'callback',      to: 'evernote#callback', as: 'evernote_callback'
      get '/',          to: 'evernote#user'
    end

    resources :users do
      resources :clippings
      resources :notes do
        get 'markdown',  to: 'notes#export_to_markdown', as: 'markdown'
        post 'evernote', to: 'notes#export_to_evernote', as: 'evernote'
        resources :fragments
      end
      post 'notes/batch',    to: 'notes#batch', as: 'batch'
      get  'notes/download/:file', to: 'notes#download_markdown', as: 'download'
    end
   
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
