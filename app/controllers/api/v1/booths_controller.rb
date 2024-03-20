class Api::V1::BoothsController < ApplicationController
  before_action :only_for_admin, only: [:create, :update, :destroy]
  before_action :set_booth, only: [:show, :update, :destroy]
  
  def index
    booths = Booth.all
    render json: { message: 'List Of All Booth', booths: booths, success: true }, status: 200
  end

  def show
    if @booth
      render json: { message: 'Booth Details', booth: @booth, success: true }, status: 200
    else
      render json: { message: 'Booth Not Foud', success: false }, status: 404
    end
  end

  def create
    booth = Booth.new(booth_params)
    if booth.save
      render json: { message: 'Created SuccessFully', success: true }, status: 200
    else
      render json: { message: booth.errors.full_messages.join(','), success: false }, status: 422
    end
  end

  def update
    if @booth
      if @booth.update(booth_params)
        render json: { message: 'Updated SuccessFully', success: true }, status: 200
      else
        render json: { message: @booth.errors.full_messages.join(','), success: false }, status: 422
      end
    else
      render json: { message: 'Booth Not Found', success: false }, status: 404
    end
  end

  def destroy
    if @booth
      @booth.destroy
      render json: { message: 'SuccessFully Deleted', success: true }, status: 200
    else
      render json: { message: 'Booth Not Found', success: false }, status: 404
    end
  end

  private
  def booth_params
    params.require(:booth).permit(:booth_name, :booth_number, :booth_lat, :booth_lon)
  end

  def set_booth
    @booth = Booth.find_by(id: params[:id])
  end
end