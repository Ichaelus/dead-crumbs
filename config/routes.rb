Rails.application.routes.draw do
  root 'hello#index'

  if Rails.env.test? || Rails.env.development?
    get :test_flash, controller: 'tests'
  end
end
