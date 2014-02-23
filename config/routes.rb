Helena::Engine.routes.draw do
  resources :surveys

  scope :admin, as: :admin, module: :admin do
    resources :surveys do
      resources :question_groups, module: :surveys
    end
  end
end
