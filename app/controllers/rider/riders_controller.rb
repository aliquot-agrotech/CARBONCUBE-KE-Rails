class Rider::RidersController < ApplicationController
  before_action :set_rider, only: [:show, :update, :destroy]

  # POST /riders
  def create
    @rider = Rider.new(rider_params)
    if @rider.save
      render json: @rider, status: :created
    else
      render json: @rider.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /riders/1
  def update
    if @rider.update(rider_params)
      render json: @rider
    else
      render json: @rider.errors, status: :unprocessable_entity
    end
  end

  # DELETE /riders/1
  def destroy
    @rider.destroy
  end

  # GET /riders/1
  def show
    render json: @rider
  end

  # GET /riders
  def index
    @riders = Rider.all
    render json: @riders
  end

  private

  def set_rider
    @rider = Rider.find(params[:id])
  end

  def rider_params
    params.require(:rider).permit(:full_name, :phone_number, :date_of_birth, :email, :id_number, :driving_license, :physical_address,:vehicle_type, :license_plate, :password, :next_of_kin_full_name, :relationship, :emergency_contact_phone_number)
  end
end
