# app/controllers/purchaser/subcategories_controller.rb
class Purchaser::SubcategoriesController < ApplicationController
  before_action :set_subcategory, only: [:show]

  # GET /purchaser/subcategories
  def index
    @subcategories = Subcategory.all
    render json: @subcategories
  end

  # GET /purchaser/subcategories/:id
  def show
    render json: @subcategory
  end

  private

  def set_subcategory
    @subcategory = Subcategory.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Subcategory not found' }, status: :not_found
  end

  def subcategory_params
    params.require(:subcategory).permit(:name, :category_id)
  end
end
