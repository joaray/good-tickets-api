Rails.application.routes.draw do
  resources :events do
    resources :tickets
  end
end
