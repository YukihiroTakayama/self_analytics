class FixedExpense < ApplicationRecord
  belongs_to :large_category, class_name: 'Category', foreign_key: 'large_category_id'
  # belongs_to :medium_category, class_name: 'Category', foreign_key: 'medium_category_id'
  # belongs_to :period

  delegate :name, to: :large_category, prefix: true
  delegate :name, to: :medium_category, prefix: true

  scope :calculating_target, -> { where(calculating_target_flag: true) }
  scope :total_price, -> { calculating_target.sum(:price) }
end
