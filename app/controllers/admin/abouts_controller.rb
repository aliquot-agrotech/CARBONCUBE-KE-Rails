class Admin::AboutsController < ApplicationController
  before_action :authenticate_admin
  before_action :set_about, only: [:show, :update, :destroy, :create, :index]

  # GET /abouts
  def index
    @abouts = About.all
    render json: @abouts
  end

  # GET /abouts/1
  def show
    render json: @about
  end

  # POST /abouts
  def create
    @about = About.new(about_params)

    if @about.save
      render json: @about, status: :created, location: @about
    else
      render json: @about.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /abouts/1
  def update
    if @about.update(about_params)
      render json: @about
    else
      render json: @about.errors, status: :unprocessable_entity
    end
  end

  # DELETE /abouts/1
  def destroy
    @about.destroy
  end

  private
    def set_about
      @about = About.find(params[:id])
    end

    def about_params
      params.require(:about).permit(:description, :mission, :vision, { values: [] }, :why_choose_us, :image_url)
    end

    def authenticate_admin
      @current_user = AdminAuthorizeApiRequest.new(request.headers).result
      unless @current_user && @current_user.is_a?(Admin)
        render json: { error: 'Not Authorized' }, status: :unauthorized
      end
    end
  
    def current_admin
      @current_user
    end
end
