Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  # get "/api/v1/merchants/:id/items", to: "api/v1/merchants/items"
  # get "/api/v1/merchants/:merchant_id/items", to: "api/v1/merchants/items"

  get "/api/v1/items/find_all", to: "api/v1/items/search#index"
  get "/api/v1/items/find", to: "api/v1/items/search#show"

  get "/api/v1/merchants/find_all", to: "api/v1/merchants/search#index"
  get "/api/v1/merchants/find", to: "api/v1/merchants/search#show"

  namespace :api do
    namespace :v1 do
      resources :merchants, only: [:index, :show] do
        resources :items, controller: "merchants/items"
        # resources :find, controller: "merchants/search", as: :merchant_search
      end
      resources :items do
        resources :merchant, controller: "items/merchant"
        # resources :find, controller: "items/search", only: [:index, :show]

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
