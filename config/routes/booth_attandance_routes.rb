resources :booth_attandances do
  member do
    put :approve_request
    put :rejecte_request
  end
end