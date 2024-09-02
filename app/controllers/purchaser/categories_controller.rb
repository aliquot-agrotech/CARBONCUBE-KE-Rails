# app/controllers/purchaser/categories_controller.rb
class Purchaser::CategoriesController < ApplicationController
  def index
    @categories = Category.includes(:subcategories).all
    render json: @categories.to_json(include: :subcategories)
  end
end
