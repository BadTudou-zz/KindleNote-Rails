Rails.application.routes.draw do
    get  'clipping',        to: 'clipping#index'
    post 'clipping/upload', to: 'clipping#upload'

  root 'welcome#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
