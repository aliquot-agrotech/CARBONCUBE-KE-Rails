class Admin::TiersController < ApplicationController
  before_action :authenticate_admin
  before_action :set_tier, only: [:show, :update, :destroy]

  def index
    @tiers = Tier.includes(:tier_pricings, :tier_features).all
    render json: @tiers.to_json(include: [:tier_pricings, :tier_features])
  end

  def show
    render json: @tier.to_json(include: [:tier_pricings, :tier_features])
  end

  def create
    @tier = Tier.new(tier_params)
    if @tier.save
      render json: @tier.to_json(include: [:tier_pricings, :tier_features]), status: :created
    else
      render json: @tier.errors, status: :unprocessable_entity
    end
  end

  def update
    ActiveRecord::Base.transaction do
      if @tier.update(tier_params)
        render json: @tier.to_json(include: [:tier_pricings, :tier_features])
      else
        raise ActiveRecord::Rollback
      end
    end
  rescue => e
    Rails.logger.error(e.message)
    render json: { error: 'Update failed' }, status: :unprocessable_entity
  end
  

  def destroy
    ActiveRecord::Base.transaction do
      # Delete associated pricing and features
      @tier.tier_pricings.destroy_all
      @tier.tier_features.destroy_all

      # Finally, delete the tier itself
      @tier.destroy!
    end

    head :no_content
  rescue StandardError => e
    Rails.logger.error(e.message)
    render json: { error: 'Failed to delete tier' }, status: :unprocessable_entity
  end

  private

  def set_tier
    @tier = Tier.find(params[:id])
  end

  def tier_params
    params.permit(
      :name,
      :ads_limit,
      tier_pricings_attributes: [:id, :duration_months, :price, :_destroy],
      tier_features_attributes: [:id, :feature_name, :_destroy]
    )
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
