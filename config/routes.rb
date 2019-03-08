Rails.application.routes.draw do
  root 'static_pages#home'
  get '/new', to:'static_pages#new'
  get '/index', to:'static_pages#index'
  post '/new', to:'contents#new'
  post '/tweet', to:'contents#tweet'
  #post '/delete' to:'content#create'
end
