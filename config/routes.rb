Rails.application.routes.draw do
  get 'sessions/new'

    get 'register',         to: 'users#new'
    post 'register',        to: 'users#create'
    get  '/login',          to: 'sessions#new'
    post   '/login',        to: 'sessions#create'
    delete '/logout',       to: 'sessions#destroy'

    get 'note/index'
    resources :users do
      resources :clippings
      resources :notes do
        resources :fragments
      end
    end
   
  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
