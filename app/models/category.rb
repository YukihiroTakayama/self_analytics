class Category < ApplicationRecord
  self.inheritance_column = :_type_disabled

  enum size: { small: 1, medium: 2, large: 3 }
  enum type: { expense: 1, income: 2 }
end
