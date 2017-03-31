Rails.application.routes.draw do
  post 'auth/login'
  post 'auth/signup'

  get 'storage/index'
  get 'storage/info'
  get 'storage/get'
  post 'storage/set'
  post 'storage/delete'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
