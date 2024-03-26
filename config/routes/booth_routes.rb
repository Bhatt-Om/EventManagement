resources :booths, except: %i[ new edit] do
  member do
    post :booth_user_allocation
  end
end