class Api::V1::ChartsController < ApiController
  def index
    @current_date = Date.today
    params[:type] ||= '0'
    params[:year] ||= @current_date.year
    params[:month] ||= @current_date.month
    @target_period = Period.find_by(year: params[:year], month: params[:month])
    @labels = labels
    @datasets = datasets
    @months = months
    @years = years
  end

  private

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
          backgroundColor: '#0000ff',
        },
        {
          type: 'bar',
          label: '支出',
          data: data_list[0].map.with_index { |price, i| i == 0 ? price : (price - data_list[0][i - 1]) },
          lineTension: 0,
          backgroundColor: '#FF0000',
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
                                .where("#{klass.to_s.downcase}_date".to_sym => range)

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
               .where("#{klass.to_s.downcase}_date".to_sym => range)
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
      while (@target_period.beginning_date.end_of_week + i) < (@target_period.end_date - 1) do
        date_ranges.push(@target_period.beginning_date..(@target_period.beginning_date.end_of_week + i))
        i += 7
      end
      date_ranges.push(@target_period.beginning_date..@target_period.end_date)
      date_ranges
    when '2'
      params[:year] ||= @current_date.year
      periods = Period.where(year: params[:year]).order(:month)
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
    years = Expense.pluck(Arel.sql("date_part('year', expense_date)")) + Income.pluck(Arel.sql("date_part('year', income_date)"))
    years.uniq!
    years ||= []
    years.sort_by! { |year| year }
    years.map { |year| ["#{year.to_i}年", year.to_i] }.to_h
  end
end