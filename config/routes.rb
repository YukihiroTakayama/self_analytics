Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :charts, only: [:index]
      resources :categories, only: %i[index update] do
        collection do
          get 'items'
        end
      end
      resources :fixed_expenses, only: %i[index create destroy]
      resources :prediction_expenses, only: %i[index create destroy]
    end
  end
end
