Helena::Engine.routes.draw do
  resources :surveys

  scope :admin, as: :admin, module: :admin do
    concern :movable do
      patch :move_up, on: :member
      patch :move_down, on: :member
    end

    resources :surveys, concerns: :movable do
      resources :question_groups, concerns: :movable do
        resources :questions, concerns: :movable
      end
    end
  end
end
