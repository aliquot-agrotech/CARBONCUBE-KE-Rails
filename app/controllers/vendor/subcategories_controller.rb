class Vendor::SubcategoriesController < ApplicationController
  def index
    # Expecting `categoryId` to be passed as a query parameter
    category_id = params[:categoryId]
    @subcategories = Subcategory.where(category_id: category_id)
    render json: @subcategories
  end
end