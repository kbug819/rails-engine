Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get "/api/v1/merchants/:id/items", to: "api/v1/merchants/items"
  # get "/api/v1/merchants/:merchant_id/items", to: "api/v1/merchants/items"

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        get "/items", to: 'merchants/items#index'
      end
      resources :items do
        get "/merchant", to: "items/merchant#index"
      end
    end
  end

  # namespace :api do
  #   namespace :v1 do
  #     resources :merchants, only: [] do
  #       resources :items, only: [:index], controller: "api/v1/merchants/items"
  #     end
  #   end
  # end

end
