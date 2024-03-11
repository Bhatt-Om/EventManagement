resources :volunteer_presences, only: %i[index create update destroy] do
  member do
    put :approved_request 
    put :rejected_request
    put :redeem_point
  end
end