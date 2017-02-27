Rails.application.routes.draw do
  devise_for :users

  root 'site#index'
  post 'site/practiced'

  # AWS IoT button
  get  'site/iot'
end
