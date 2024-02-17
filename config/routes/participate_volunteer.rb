resources :participate_volunteers, only: %i[index create destroy] do
  member do
    post :through_qr_code
    post :scan_qr_code
    put :approved_request 
    put :rejected_request
  end
end