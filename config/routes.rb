Helena::Engine.routes.draw do
  resources :surveys

  scope :admin, as: :admin, module: :admin do
    resources :surveys do
      resources :question_groups, module: :surveys do
        patch :move_up, on: :member
        patch :move_down, on: :member
      end

      patch :move_up, on: :member
      patch :move_down, on: :member
    end
  end
end
