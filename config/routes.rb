Rails.application.routes.draw do
  resources :events do
    resources :tickets, only: %i[index show create]
  end
end
