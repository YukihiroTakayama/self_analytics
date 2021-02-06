class Budget < ApplicationRecord
  belongs_to :category
  belongs_to :period

  after_initialize :add_period_id

  def add_period_id
    return if period_id.present?

    period_id = Period.target_period(Date.today).id
    self.period_id = period_id
  end
end
