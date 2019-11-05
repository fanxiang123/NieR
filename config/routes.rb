Rails.application.routes.draw do
  get 'happy_birthday/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  #
  root "welcome#index"
  root "happy_birthday#index"
end
