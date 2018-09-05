Rails.application.routes.draw do
  resources :chapters
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'home#index'
  
  get '/leaderboard' => 'home#leaderboard'
  get '/maze/room/:room_number' => 'chapters#room'

  mount ActionCable.server => '/cable'

end
