Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ja/ do
    get 'static_pages/home'
    get 'static_pages/help'
    get 'static_pages/contact'
    root 'static_pages#home'
    # resource :static_pages do
    #   collection do
    #     get :index
    #     get :help
    #     get :home
    #   end
    # end
    resources :microposts, only: [:create, :destroy, :index] do
      resources :comments
      resources :likes
    end
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/delete/:id", to: "users#destroy"
    resources :users do
      member do
        get :following, :followers
      end
      collection { post :import }
      collection { get :export }
    end
    resources :relationships, only: [:create, :destroy]
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    get "/logout", to: "sessions#destroy"
    resources :account_activations, only: :edit
    resources :password_resets, only: [:new, :create, :edit, :update] 
    namespace :api, defaults: { format: :json } do
      namespace :v1 do
        post "/login", to: "sessions#create"
        post "/comment", to: "microposts#comment"
        resources :users
        resources :microposts, only: [:index]
      end
    end
  end
end
