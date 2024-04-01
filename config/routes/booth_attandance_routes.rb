resources :booth_attandances do
  member do
    put :approve_request
    put :rejecte_request
  end
end
post 'scane_qr/:booth_id', to: 'booth_attandances#scane_qr_code'