Helena::Engine.routes.draw do
  resources :surveys

  scope :admin, as: :admin, module: :admin do
    concern :movable do
      patch :move_up, on: :member
      patch :move_down, on: :member
    end

    resources :surveys, concerns: :movable do
      resources :versions, only: [:index] # TODO: make an index
      resources :question_groups, concerns: :movable do
        resources :questions, concerns: :movable
        resource :questions do
          resources :short_texts, module: 'questions'
          resources :long_texts, module: 'questions'
          resources :static_texts, module: 'questions'
          resources :radio_groups, module: 'questions'
          resources :checkbox_groups, module: 'questions'
          resources :radio_matrix, module: 'questions'
          resources :checkbox_matrix, module: 'questions'
        end
      end
    end
  end
end
