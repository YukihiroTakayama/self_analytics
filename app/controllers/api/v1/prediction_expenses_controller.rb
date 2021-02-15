class Api::V1::PredictionExpensesController < ApplicationController
  protect_from_forgery except: %i[create update]

  def index
    @prediction_expenses = PredictionExpense.calculating_target.order(:large_category_id)
  end

  def create
    prediction_expense = PredictionExpense.find_by(id: params[:id]) || PredictionExpense.create(prediction_expense_params)
    prediction_expense_params.delete(:id)
    prediction_expense.update!(prediction_expense_params)
  end

  def update
    prediction_expense = PredictionExpense.find(params[:id])
    prediction_expense.update!(prediction_expense_params)
  end

  def destroy
    prediction_expense = PredictionExpense.find(params[:id])
    prediction_expense.update!(calculating_target_flag: false)
  end

  def prediction_expense_params
    params.require(:expense).permit(:content, :price, :calculating_target_flag)
          .merge(large_category_id: params.require(:expense).require(:large_category)[:id])
  end
end
