Rails.application.routes.draw do
  resources :applications, param: :token, except: [:destroy] do
    resources :chats, only: [:index,:create, :update, :show] do
      resources :messages, only: [:create, :update, :show]
    end
  end
  resources :chats, only: [:index,:create,:show]
  resources :messages, only: [:index]

  resources :messages, only: [:show, :create] do
    collection do
      get 'search'
    end
  end
end
