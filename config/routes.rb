Helena::Engine.routes.draw do
  resources :surveys
  resources :sessions, param: :token
end
