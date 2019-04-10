Rails.application.routes.draw do
  root 'contents#home'
  get '/success', to:'contents#success', as:'success'
  match '/tweet', to:'contents#tweet', via: [:post], as: 'tweet'
  match '/auto_tweet', to:'contents#auto_tweet', via: [:post], as: 'auto_tweet'
  resources :contents, except:[:show, :edit, :update]
end
