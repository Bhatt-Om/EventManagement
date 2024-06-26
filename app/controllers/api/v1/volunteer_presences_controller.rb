class Api::V1::VolunteerPresencesController < ApplicationController
  before_action :only_for_admin, only: %i[approved_request rejected_request]
  before_action :set_volunteer_presence, only: %i[update destroy approved_request rejected_request redeem_point]
  has_scope :request_type
  has_scope :requst_status
  has_scope :task_id

  def index
    volunteer_presences = current_user.is_admin? ? VolunteerPresence.all : current_user.volunteer_presences
    volunteer_presences = apply_scopes(volunteer_presences).all.includes(participate_volunteer: [:user, :task, :qr_code_attachment], upload_proof_attachment: :blob ).order(id: :desc)
    render json: { message: 'List Of Presence', volunteer_presences: volunteer_presences, success: true }, status: 200
  end

  def create
    volunteer_presence = VolunteerPresence.find_or_initialize_by(volunteer_presence_params.slice(:participate_volunteer_id))

    if volunteer_presence.persisted?
      return render json: { message: 'Already Uplodad' , success: true }, status: 200
    end
    
    volunteer_presence.assign_attributes(volunteer_presence_params.slice(
      :request_type,
      :requst_status,
      :location,
      :volunteer_lon,
      :volunteer_lat
    ))

    if volunteer_presence.volunteer_lat && volunteer_presence.volunteer_lon
      distance = volunteer_presence.distance_between(volunteer_presence.task.task_lat, volunteer_presence.task.task_lon, volunteer_presence.volunteer_lat, volunteer_presence.volunteer_lon)
      volunteer_presence.distance = distance
      if distance <= 0.1000
        ActiveRecord::Base.transaction do
          volunteer_presence.user.update(points: (volunteer_presence.user.points.to_i + volunteer_presence.task.points.to_i).to_s)
        end
        volunteer_presence.requst_status = 1
      end
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
      ActiveRecord::Base.transaction do
        @volunteer_presence.user.update(points: (@volunteer_presence.user.points.to_i + @volunteer_presence.task.points.to_i).to_s)
        @volunteer_presence.update(requst_status: 1)
        render json: { message: 'SuccessFully Approved', success: true }, status: 200
      end
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

  def redeem_point
    if @volunteer_presence
      if @volunteer_presence.redeemed_points == false
        @volunteer_presence.update(redeemed_points: true)
        @volunteer_presence.user.update(points: (@volunteer_presence.user.points.to_i - @volunteer_presence.task.points.to_i).to_s)
        @volunteer_presence.user.update(redeemed: (@volunteer_presence.user.redeemed.to_i + @volunteer_presence.task.points.to_i).to_s)
        render json: { message: 'successfully redeemed', success: true }, status: 200
      else
        render json: { message: 'already redeemed', success: true }, status: 200
      end
    else
      render json: { message: 'Not Found', success: false }, status: 404
    end
  end


  private

  def volunteer_presence_params
    params.require(:volunteer_presence).permit(:participate_volunteer_id, :request_type, :requst_status, :location, :volunteer_lon, :volunteer_lat, :upload_proof)
  end

  def set_volunteer_presence
    @volunteer_presence = VolunteerPresence.find_by(id: params[:id])
  end
end
