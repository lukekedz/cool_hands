Rails.application.routes.draw do
  devise_for :users

  root 'site#index'
  post 'site/practiced'

  get  'site/iot'
end
