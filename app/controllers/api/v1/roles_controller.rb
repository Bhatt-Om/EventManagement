class Api::V1::RolesController < ApplicationController
before_action :only_for_admin
before_action :set_role, only: %i[ update destroy ]
  
  def index
    roles = Role.all.order(id: :desc)
    render json: { message: 'List Of All Roles', roles: roles, success: true }, status: 200
  end

  def create
    role = Role.new(role_params)
    if role.save
      render json: { message: 'Role Created SucceesFully', success: true }, status: 201
    else
      render json: { message: role.errors.full_messages.join(','), success: false }, status: 422
    end
  end

  def update
    if @role.update(role_params)
      render json: { message: "SucceesFully Updated", success: true }, status: 200
    else
      render json: { message: @role.errors.full_messages.join(','), success: false }, status: 422
    end
  end

  def destroy
    @role.destroy
    render json: { message: 'SuccessFully Deleted Role', success: true }, status: 200
  end


  private

  def role_params
    params.require(:role).permit(:role_name)
  end

  def set_role
    @role = Role.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'Role not found' }, status: 404
  end
end