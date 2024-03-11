resources :participate_volunteers, only: %i[index create destroy] do
  member do
    post :generate_qr
    post :scan_qr_code
    put :approved_request 
    put :rejected_request
  end
end