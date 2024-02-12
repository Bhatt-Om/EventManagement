resources :participate_volunteers, only: %i[index create destroy] do
  collection do
    put :approved_request
    put :rejected_request
  end
end