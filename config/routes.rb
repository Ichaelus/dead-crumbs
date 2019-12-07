Rails.application.routes.draw do
  root 'secrets#index'

  resources :secrets, only: [] do
    collection do
      get :generate
      get ":room/generate", action: :generate
      post ":room/generate", action: :create_key_parts
      get :combine
      get ":room/combine", action: :combine
      post ":room/combine", action: :queue_part_combination
    end
  end

  if Rails.env.test? || Rails.env.development?
    get :test_flash, controller: 'tests'
  end
end
