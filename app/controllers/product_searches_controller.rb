class ProductSearchesController < ApplicationController
  def create
    product_search = ProductSearch.new(product_search_params)

    if product_search.save
      render json: { message: 'Search logged successfully' }, status: :created
    else
      render json: { errors: product_search.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def product_search_params
    params.permit(:search_term, :purchaser_id)
  end
end
