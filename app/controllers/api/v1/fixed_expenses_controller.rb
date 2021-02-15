class Api::V1::FixedExpensesController < ApplicationController
  protect_from_forgery except: %i[create update]

  def index
    @fixed_expenses = FixedExpense.calculating_target.order(:large_category_id)
  end

  def create
    fixed_expense = FixedExpense.find_by(id: params[:id]) || FixedExpense.create(fixed_expense_params)
    fixed_expense_params.delete(:id)
    fixed_expense.update!(fixed_expense_params)
  end

  def update
    fixed_expense = FixedExpense.find(params[:id])
    fixed_expense.update!(fixed_expense_params)
  end

  def destroy
    fixed_expense = FixedExpense.find(params[:id])
    fixed_expense.update!(calculating_target_flag: false)
  end

  def fixed_expense_params
    params.require(:expense).permit(:content, :price, :calculating_target_flag)
          .merge(large_category_id: params.require(:expense).require(:large_category)[:id])
  end
end
