class Admin::CategoriesController < ApplicationController
  before_action :authenticate_admin
  before_action :set_category, only: [:show, :update, :destroy, :add_subcategory, :remove_subcategory]

  def index
    @categories = Category.includes(:subcategories).all
    render json: @categories.to_json(include: :subcategories)
  end

  def show
    render json: @category.to_json(include: :subcategories)
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category.to_json(include: :subcategories), status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def update
    if @category.update(category_params)
      render json: @category.to_json(include: :subcategories)
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    head :no_content
  end

  def add_subcategory
    subcategory = @category.subcategories.build(subcategory_params)
    if subcategory.save
      render json: subcategory, status: :created
    else
      render json: subcategory.errors, status: :unprocessable_entity
    end
  end

  def remove_subcategory
    subcategory = @category.subcategories.find(params[:subcategory_id])
    subcategory.destroy
    head :no_content
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :description, subcategories_attributes: [:id, :name, :description, :_destroy])
  end

  def subcategory_params
    params.require(:subcategory).permit(:name, :description)
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
