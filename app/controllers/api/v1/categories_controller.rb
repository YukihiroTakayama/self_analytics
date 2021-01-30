class Api::V1::CategoriesController < ApplicationController
  protect_from_forgery only: [:update]

  def index
    @period_id = Period.target_period(Date.today).id
    @categories = Category.includes(:budget).large.order(:id)
  end

  def update
    @category = Category.find(params[:id])
    Budget.create(category_id: params[:id]) if @category.budget.nil?
    @category.update!(category_params)
  end

  def category_params
    params.require(:category).permit(:color, budget_attributes: %i[price warning_percent])
  end
end
