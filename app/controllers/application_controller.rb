class ApplicationController < ActionController::Base
  before_action :doorkeeper_authorize!
  protect_from_forgery with: :null_session

  def after_resetting_password_path_for(resource)
    redirect_to 'http://localhost:3001/'
  end

  private

  def current_user
    @current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end

  def only_for_admin
    unless current_user&.is_admin?
      render json: { message: current_user ? 'You are not allowed to perform this action' : 'Please Login', success: false }, status: 401
    end
  end
end
