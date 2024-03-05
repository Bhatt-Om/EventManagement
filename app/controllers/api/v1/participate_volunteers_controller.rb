sclass Api::V1::ParticipateVolunteersController < ApplicationController
  before_action :only_for_admin, only: %i[approved_request rejected_request]
  before_action :set_participate_volunteer, only: %i[destroy approved_request rejected_request through_qr_code scan_qr_code]
  skip_before_action :doorkeeper_authorize!, only: %i[scan_qr_code]
  has_scope :request_type

  def index
    participate_volunteer = current_user.is_admin? ? ParticipateVolunteer.admin : ParticipateVolunteer.user(current_user.id)
    participate_volunteer = apply_scopes(participate_volunteer).all.includes(:user, task: [:event_poster_attachment], qr_code_attachment: :blob).order(id: :desc)
    render json: { message: 'List Of all Pending Or Approved Request', participate_volunteer: participate_volunteer, success: true }, status: 200
  end

  def create
    participate_volunteer = ParticipateVolunteer.find_or_initialize_by(participate_volunteer_params)
    
    if participate_volunteer.persisted?
      return render json: { message: "Already Registerd", success: true }, status: 200
    end
    if participate_volunteer.save
      render json: { message: "SuccessFully Participated #{participate_volunteer.task.event_name}", success: true }, status: 200
    else
      render json: { message: participate_volunteer.errors.full_messages.join(', '), success: false }, status: 422
    end
  end

  def approved_request
    if @participate_volunteer
      @participate_volunteer.update(participate_request: 1)
      @participate_volunteer.user.update(points: (@participate_volunteer.user.points.to_i + @participate_volunteer.task.points.to_i).to_s)
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

  def through_qr_code
    if @participate_volunteer
      @participate_volunteer.generate_qr_code if @participate_volunteer.participate_request == 'approved'
      render json: { message: 'SuccessFully Generated QR', success: true }, status: 200
    else
      render json: { message: 'Not Found', success: false }, status: 404
    end
  end

  def scan_qr_code
    if @participate_volunteer

      if @participate_volunteer.volunteer_presence.present? 
        return render json: { message: "Already Registerd", success: true }, status: 200
      end

      @participate_volunteer.build_volunteer_presence(participate_volunteer_id: @participate_volunteer.id, request_type: 2)
      if @participate_volunteer.save
        render json: { message: 'SuccessFully Requested', success: true }, status: 200
      else
        render json: { message: @participate_volunteer.errors.full_messages.join(','), success: false }, status: 422
      end
    else
      render json: { message: 'Not Found', success: false }, status: 404
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
