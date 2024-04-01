class Api::V1::BoothAttandancesController < ApplicationController
  before_action :only_for_admin, only: %i[ update destroy approve_request rejecte_request ]
  before_action :set_booth_attandance, only: %i[ update destroy approve_request rejecte_request ]

  def index
    attandances = current_user.is_admin? ? BoothAttandance.all : current_user.booth ? BoothAttandance.where(booth_id: current_user.booth.id) : []
    render json: { message: 'list of all booths attadance', attandances: attandances, success: true }, status: 200
  end

  def create
    booth_attandance = BoothAttandance.new(booth_attandance_params)
     if booth_attandance.user_lat && booth_attandance.user_lot
      distance = booth_attandance.distance_between(booth_attandance.booth.booth_lat, booth_attandance.booth.booth_lon, booth_attandance.user_lat, booth_attandance.user_lot)
      if distance <= 0.1000
        booth_attandance.request_stats = 'approved'
      end
     end
    
    booth_attandance.image.attach(booth_attandance_params['image']) if booth_attandance_params['image']
    if booth_attandance.save
      render json: { message: 'SuccessFully Check in', success: true }, status: 201
    else
      render json: { message: booth_attandance.errors.full_messages.join(','), success: false }, status: 422
    end
  end

  def update
    if @booth_attandance.update(booth_attandance)
      render json: { message: 'Success', success: true }, status: 200
    else
      render json: { message: @booth_attandance.errors.full_messages.join(','), success: false }, status: 422
    end
  end

  def destroy
    @booth_attandance.destroy
    render json: { message: 'Success', success: true }, status: 200
  end

  def approve_request
    @booth_attandance.update(request_stats: 'approved')
    render json: { message: 'SuccessFully Approved', success: true }, status: 200
  end

  def rejecte_request
    @booth_attandance.update(request_stats: 'rejected')
    render json: { message: 'SuccessFully Rejecte', success: true }, status: 200
  end

  def scane_qr_code
    booth = Booth.find_by(id: params[:booth_id])
    if booth
      booth_attandance = BoothAttandance.new(booth_attandance_params)
      booth_attandance.booth_id = params[:booth_id]
      booth_attandance.request_type = 'qr_code'
      if booth_attandance.user_lat && booth_attandance.user_lot
        distance = booth_attandance.distance_between(booth_attandance.booth.booth_lat, booth_attandance.booth.booth_lon, booth_attandance.user_lat, booth_attandance.user_lot)
        if distance <= 0.1000
          booth_attandance.request_stats = 'approved'
        end
       end
      
      booth_attandance.image.attach(booth_attandance_params['image']) if booth_attandance_params['image']
      if booth_attandance.save
        render json: { message: 'SuccessFully check in', success: true }, status: 200
      else
        render json: { message: booth_attandance.errors.full_messages.join(','), success: false }, status: 422
      end
    else
      render json: { message: 'Booth not found', success: false }, status: 404
    end
  end
  private

  def booth_attandance_params
    params.require(:booth_attandance).permit(:booth_id, :date, :time, :request_type, :request_stats, :user_lat, :user_lot, :image)
  end

  def set_booth_attandance
    @booth_attandance = BoothAttandance.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { message: 'not found' }, status: 404
  end
end