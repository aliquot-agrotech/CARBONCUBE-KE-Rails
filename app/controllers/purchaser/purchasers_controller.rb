# app/controllers/purchasers_controller.rb

class Purchaser::PurchasersController < ApplicationController
    
    # GET /purchasers
    def index
      @purchasers = Purchaser.all
      render json: @purchasers
    end
  
    # GET /purchasers/:id
    def show
      @purchaser = Purchaser.find(params[:id])
      render json: @purchaser
    end
  
    # POST /purchasers
  def create
    @purchaser = Purchaser.new(purchaser_params)

    if @purchaser.save
      token = JsonWebToken.encode(purchaser_id: @purchaser.id, role: @purchaser.role)
      render json: { token: token, purchaser: @purchaser }, status: :created
    else
      render json: { errors: @purchaser.errors.full_messages }, status: :unprocessable_entity
    end
  end
  
    # PATCH/PUT /purchasers/:id
    def update
      @purchaser = Purchaser.find(params[:id])
  
      if @purchaser.update(purchaser_params)
        render json: @purchaser
      else
        render json: { errors: @purchaser.errors.full_messages }, status: :unprocessable_entity
      end
    end
  
    # DELETE /purchasers/:id
    def destroy
      @purchaser = Purchaser.find(params[:id])
      @purchaser.destroy
      head :no_content
    end

  
    private
  
    def purchaser_params
      params.require(:purchaser).permit(:fullname, :username, :phone_number, :email, :location, :password, :password_confirmation)
    end
  end
  