class Api::V1::ChartsController < ApiController
  def index
    params[:type] = '0'
    @target_period = target_period
    @labels = labels
    @datasets = datasets
    @months = months
    @years = years
    @pie_chart_data = pie_chart_data
    @amount = amount
    @categories = Category.where(type: 1)
                          .where(size: params[:category_size] || Category.sizes[:large])
                          .order(:id)
  end

  private

  def target_period
    today = Date.today
    today_period = Period.target_period(today)
    year = today_period.year + params[:year].to_i
    month = today_period.month + params[:month].to_i
    Period.find_by(year: year, month: month)
  end

  def datasets
    if params[:type] == '0'
      data_list = aggregate_data
      [
        {
          type: 'line',
          label: '収支',
          data: data_list[1].map.with_index { |data, i| data - data_list.first[i] },
          lineTension: 0,
          borderColor: '#FFFFFF'
        },
        {
          type: 'bar',
          label: '収入',
          data: data_list[1].map.with_index { |price, i| i == 0 ? price : price - data_list[1][i - 1] },
          lineTension: 0,
          backgroundColor: '#0000ff'
        },
        {
          type: 'bar',
          label: '支出',
          data: data_list[0].map.with_index { |price, i| (i == 0 ? price : (price - data_list[0][i - 1])) * -1 },
          lineTension: 0,
          backgroundColor: '#FF0000'
        }
      ]
    else
      categories.map do |category|
        {
          id: category.id,
          label: category.name,
          data: aggregate_data.map { |data| data[category.id].to_i },
          fill: false,
          borderColor: category.color,
          lineTension: 0
        }
      end
    end
  end

  def categories
    Category.where(type: params[:type] || 1)
            .where(size: params[:category_size] || Category.sizes[:large])
            .order(:id)
  end

  def aggregate_data
    klasses = case params[:type]
              when '1' then [Expense]
              when '2' then [Income]
              else [Expense, Income]
              end

    if params[:type] == '0'
      data_list = []
      klasses.each do |klass|
        data = date_ranges.map do |range|
          aggregate_data = klass.calculating_target
                                .where(transaction_date: range)

          aggregate_data = aggregate_data.group((params[:category_size] || 'large') + '_category_id') unless params[:type] == '0'
          aggregate_data.sum(:price)
        end
        data_list.push(data)
      end
      data_list
    else
      klasses.each do |klass|
        data_list = date_ranges.map do |range|
          klass.calculating_target
               .where(transaction_date: range)
               .group((params[:category_size] || 'large') + '_category_id')
               .sum(:price)
        end
      end
    end
    data_list
  end

  def date_ranges
    case params[:x_axis]
    when '0'
      (@target_period.beginning_date..@target_period.end_date).map do |date|
        (@target_period.beginning_date..date)
      end
    when '1'
      date_ranges = []
      i = 0
      while (@target_period.beginning_date.end_of_week + i) < (@target_period.end_date - 1)
        date_ranges.push(@target_period.beginning_date..(@target_period.beginning_date.end_of_week + i))
        i += 7
      end
      date_ranges.push(@target_period.beginning_date..@target_period.end_date)
      date_ranges
    when '2'
      periods = Period.where(year: @target_period.year).order(:month)
      (0..11).map do |i|
        periods[0].beginning_date..periods[i].end_date
      end
    else
      []
    end
  end

  def labels
    case params[:x_axis]
    when '0'
      date_ranges.map { |range| range.last.strftime('%m/%d') }
    when '1'
      date_ranges.map { |range| range.first.strftime('%m/%d') + '~' + range.last.strftime('%m/%d') }
    when '2'
      date_ranges.map { |range| range.last.strftime('%-m月') }
    end
  end

  def months
    (1..12).map { |i| ["#{i}月", i] }.to_h
  end

  def years
    years = Expense.pluck(Arel.sql("date_part('year', transaction_date)")) + Income.pluck(Arel.sql("date_part('year', transaction_date)"))
    years.uniq!
    years ||= []
    years.sort_by! { |year| year }
  end

  def pie_chart_data
    total_expense_price = @target_period.expenses.sum(:price)
    large_category_price_list = @target_period.expenses.group(:large_category_id).sum(:price)
    categories = Category.where(id: large_category_price_list.keys)
    labels = categories.pluck(:name)
    colors = categories.pluck(:color)
    {
      datasets: [{
        data: large_category_price_list.values,
        backgroundColor: colors
      }],
      labels: labels
    }
  end

  def amount
    return 0 if @target_period.month == 1

    prev_month = @target_period.month - 1
    expenses = Expense.joins(:period).calculating_target.where(periods: { year: @target_period.year, month: (1..prev_month) }).sum(:price)
    incomes = Income.joins(:period).calculating_target.where(periods: { year: @target_period.year, month: (1..prev_month) }).sum(:price)
    incomes - expenses
  end
end
