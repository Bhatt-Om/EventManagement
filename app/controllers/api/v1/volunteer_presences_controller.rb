class Api::V1::VolunteerPresencesController < ApplicationController
  before_action :only_for_admin, only: %i[approved_request rejected_request]
  before_action :set_volunteer_presence, only: %i[update destroy]
  def index
    volunteer_presences = VolunteerPresence.includes(:participate_volunteer)
    if current_user.is_admin?
      volunteer_presences = volunteer_presences.order(id: :desc)
    else
      volunteer_presences = volunteer_presences.joins(:participate_volunteer).where(participate_volunteer: {user_id: current_user.id})
    end

    if params[:request_type].present? && params[:request_status].present?
      volunteer_presences = volunteer_presences.where(request_type: params[:request_type], request_status: params[:request_status]).order(id: :desc)
    end
    render json: { message: 'List Of Presence', volunteer_presences: volunteer_presences, success: true }, status: 200
  end

  def create
    volunteer_presence = VolunteerPresence.new(volunteer_presence_params)
    if volunteer_presence.save
      render json: { message: 'Success Fully Submited', success: true }, status: 200
    else
      render json: { message: volunteer_presence.errors.full_messages.join(', '), success: false }, status: 422
    end
  end

  def update
    if @volunteer_presence
      if @volunteer_presence.update(volunteer_presence_params)
        render json: { message: 'sucess fully updated', success: true }, status: 200
      else
        render json: { message: @volunteer_presence.errors.full_messages.join(','), success: false }, status: 422
      end
    else
      render json: { message: 'Not Found', success: false }, status: 404
    end
  end

  def destroy
    if @volunteer_presence
      @volunteer_presence.destroy
      render json: { message: 'SuccessFully Destroyed', success: true }, status: 200
    else
      render json: { message: 'Not Found', success: false }, status: 404
    end
  end

  def approved_request
    if @volunteer_presence
      @volunteer_presence.update(requst_status: 1)
      render json: { message: 'SuccessFully Approved', success: true }, status: 200
    else
      render json: { message: 'Not Found', success: false }, status: 404
    end
  end

  def rejected_request
    if @volunteer_presence
      @volunteer_presence.update(requst_status: 2)
      render json: { message: 'SuccessFully Rejected', success: true }, status: 200
    else
      render json: { message: 'Not Found', success: false }, status: 404
    end
  end

  private

  def volunteer_presence_params
    params.require(:volunteer_presence).permit(:participate_volunteer_id, :request_type, :requst_status, :location, :upload_proof)
  end

  def set_volunteer_presence
    @volunteer_presence = VolunteerPresence.find_by(id: params[:id])
  end
end