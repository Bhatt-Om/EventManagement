resources :users, only: %i[create show] do
  collection do
    get :find_user
    get :app_credentials
    post :login
    post :forgot_password
  end
end
