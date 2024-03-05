resources :users, only: %i[index create show] do
  collection do
    get :find_user
    get :app_creds
    post :login
    post :forgot_password
    put :update_profile
    post :send_otp
  end
end
