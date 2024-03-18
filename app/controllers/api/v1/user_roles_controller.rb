class Api::V1::UserRolesController < ApplicationController

  def index
    roles = UserRole.all
    render json: { message: 'list of all roles', roles: roles, success: true }, status: 200
  end

  def create
    role = UserRole.new(role_params)
    if role.save
      render json: { message: 'Role Created', success: true },status: 201
    else
      render json: { message: role.errors.full_messages.join(', '), success: false }, status: 422
    end
  end


  def update
    role = UserRole.find_by(id: params[:id])
    if role
      if role.update(role_params)
        render json: { message: 'Updated SuccessFully', success: true }, status: 200
      else
        render json: { message: role.errors.full_messages.join(', '), success: false }, status: 422
      end
    else
      render json: { message: 'Role not found', success: false  }, status: 404
    end
  end
  
  private

  def role_params
    params.require(:user_role).permit(:role_name)
  end
end