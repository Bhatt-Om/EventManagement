Rails.application.routes.draw do
  devise_for :users, controllers: {
    passwords: 'user/passwords'
  }
  use_doorkeeper do
    skip_controllers :authorizations, :applications, :authorized_applications
  end
  get "up" => "rails/health#show", as: :rails_health_check

  namespace :api do
    namespace :v1 do
      draw(:user)
      draw(:task)
      draw(:participate_volunteer)
      draw(:volunteer_presences)
      draw(:user_role_routes)
    end
  end
end
