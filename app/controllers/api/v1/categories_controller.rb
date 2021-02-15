class Api::V1::CategoriesController < ApplicationController
  protect_from_forgery only: [:update]

  def index
    @period_id = Period.target_period(Date.today).id
    @categories = Category.includes(:budget).large.order(:id)
  end

  def update
    @category = Category.find(params[:id])
    @category.update(category_params)
  end

  def items
    categories = params[:size] == 'medium' ? Category.medium : Category.large

    render json: { items: categories }
  end

  def category_params
    params.require(:category).permit(:color, budget_attributes: %i[price warning_percent])
  end
end
