Helena::Engine.routes.draw do
  resources :surveys
  resources :sessions, only: [:show, :edit, :update], param: :token
end
