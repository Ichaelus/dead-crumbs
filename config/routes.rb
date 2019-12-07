Rails.application.routes.draw do
  root 'secrets#index'

  resources :secrets, only: [] do
    collection do
      get :generate
      get ":room/generate", action: :generate
      post :generate
      get :combine
      post :combine
    end
  end

  if Rails.env.test? || Rails.env.development?
    get :test_flash, controller: 'tests'
  end
end
