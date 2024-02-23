class Api::V1::VolunteerPresencesController < ApplicationController
  before_action :only_for_admin, only: %i[approved_request rejected_request]
  before_action :set_volunteer_presence, only: %i[update destroy]
  def index
    volunteer_presences = VolunteerPresence.all
    if current_user.is_admin?
      volunteer_presences = volunteer_presences
    else
      # volunteer_presences = volunteer_presences.joins(:participate_volunteer).where(participate_volunteer: {user_id: current_user.id})
      volunteer_presences = current_user.volunteer_presences
    end
    volunteer_presences = volunteer_presences.includes(:participate_volunteer, upload_proof_attachment: :blob ).order(id: :desc)
    render json: { message: 'List Of Presence', volunteer_presences: volunteer_presences, success: true }, status: 200
  end

  def create
    volunteer_presence = VolunteerPresence.find_or_initialize_by(volunteer_presence_params.except(:upload_proof))

    if volunteer_presence.persisted?
      return render json: { message: 'Already Uplodad' , success: true }, status: 200
    end
    volunteer_presence.upload_proof.attach(volunteer_presence_params['upload_proof']) if volunteer_presence_params['upload_proof']
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
