Rails.application.routes.draw do
  get 'sessions/new'

    get 'register',         to: 'user#new'
    post 'register',        to: 'user#create'
    get 'user/show',        to: 'user#show'
    get  '/login',          to: 'sessions#new'
    post   '/login',        to: 'sessions#create'
    delete '/logout',       to: 'sessions#destroy'

    get 'note/index'

    get  'clipping',        to: 'clipping#index'
    post 'clipping/upload', to: 'clipping#upload'

    resources :note
    resources :fragments
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
