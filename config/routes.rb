Rails.application.routes.draw do
  root 'static_pages#home'
  get '/new', to:'static_pages#new'
  get '/index', to:'static_pages#index'
  get '/success', to:'static_pages#success'
  match '/tweet', to:'contents#tweet', via: [:post]

  resources :contents, only:[:create, :tweet, :destroy]
end
