Rails.application.routes.draw do
  post 'auth/signup'
  post 'auth/register_device'
  post 'storage/get'
  post 'storage/set'
  post 'storage/delete'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
