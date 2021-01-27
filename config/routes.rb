Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, { format: 'json' } do
    namespace :v1 do
      resources :charts, only: [:index]
      resources :categories, only: %i[index update]
    end
  end
end
