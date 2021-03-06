Rails.application.routes.draw do

  scope "(:locale)", locale: /en|vi/ do
    root "static_pages#home"
    get "/help", to: "static_pages#help"
    get "/about", to: "static_pages#about"
    get "/contact", to: "static_pages#contact"
    get "/signup", to: "users#new"
    post "/signup", to: "users#create"
    get "/edit", to: "users#edit"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/new", to: "pasword_reset#new"
    get "/edit", to: "pasword_reset#edit"
    resources :users do
      member do
        get :following, :followers
      end
    end

    resources :microposts do 
      member do
        put "like", to: "microposts#upvote"
        put "dislike", to: "microposts#downvote"
      end

      resources :comments
    end
    resources :comments
    resources :account_activations, only: :edit
    resources :password_resets, only: [:new, :create, :edit, :update]
    resources :microposts, only: [:create, :destroy]
    resources :relationships, only: [:create, :destroy]
  end
end
