class Api::V1::ParticipateVolunteersController < ApplicationController
  before_action :only_for_admin, only: %i[approved_request]
  before_action :set_participate_volunteer, only: %i[destroy approved_request rejected_request]

  def index
    participate_volunteer = ParticipateVolunteer.includes(:user, :task)
    if current_user.is_admin?
      participate_volunteer = participate_volunteer.where(participate_request: params[:request_type]).order(id: :desc) if params[:request_type].present?
    else
      participate_volunteer = participate_volunteer.where(user_id: current_user.id)
      participate_volunteer = participate_volunteer.where(participate_request: params[:request_type]).order(id: :desc) if params[:request_type].present?
    end
    render json: { message: 'List Of all Pending Or Approved Request', participate_volunteer: participate_volunteer, success: true }, status: 200
  end

  def create
    participate_volunteer = ParticipateVolunteer.new(participate_volunteer_params)
    if participate_volunteer.save
      render json: { message: "SuccessFully Participated #{participate_volunteer.task.event_name}", success: true }, status: 200
    else
      render json: { message: participate_volunteer.errors.full_messages.join(', '), success: false }, status: 422
    end
  end

  def approved_request
    if @participate_volunteer
      @participate_volunteer.update(participate_request: 1)
      render json: { message: 'Approved The Request', success: true }, status: 200
    else
      render json: { message: 'Not Fond', suucess: false }, status: 404
    end
  end

  def rejected_request
    if @participate_volunteer
      @participate_volunteer.update(participate_request: 2)
      render json: { message: 'Rejected The Request', success: true }, status: 200
    else
      render json: { message: 'Not Fond', suucess: false }, status: 404
    end
  end

  def destroy
    if @participate_volunteer
      @participate_volunteer.destroy
      render json: { message: 'SuccessFully Removed', success: true }, status: 200
    else
      render json: { message: 'Not Fond', suucess: false }, status: 404
    end
  end

  private

  def participate_volunteer_params
    params.require(:participate).permit(:task_id, :user_id)
  end

  def set_participate_volunteer
    @participate_volunteer = ParticipateVolunteer.find_by(id: params[:id])
  end
end
