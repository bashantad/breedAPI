Rails.application.routes.draw do
  resources :breeds, except: [:edit, :new] do
    get :tags
    post :tags
    get :stats, on: :collection
  end

  resources :tags, only: [:index, :show, :update, :destroy] do
    get :stats, on: :collection
  end

end
