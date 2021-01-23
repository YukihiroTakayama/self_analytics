class Api::V1::CategoriesController < ApplicationController

  protect_from_forgery only: [:update]

  def index
    @categories = Category.large.order(:id)
  end

  def update
    category = Category.find(params[:id])
    category.update(color: params[:color])
  end
end
