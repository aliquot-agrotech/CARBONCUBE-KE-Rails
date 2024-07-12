class Admin::CategoriesController < ApplicationController
    before_action :authenticate_admin
    before_action :set_category, only: [:show, :update, :destroy]
  
    def index
      @categories = Category.all
      render json: @categories
    end
  
    def show
      render json: @category
    end
  
    def create
      @category = Category.new(category_params)
      if @category.save
        render json: @category, status: :created
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end
  
    def update
      if @category.update(category_params)
        render json: @category
      else
        render json: @category.errors, status: :unprocessable_entity
      end
    end
  
    def destroy
      @category.destroy
      head :no_content
    end
  
    private
  
    def set_category
      @category = Category.find(params[:id])
    end
  
    def category_params
      params.require(:category).permit(:name, :description)
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
  