class Notification < ApplicationRecord
  scope :notified, -> { where(notified_flag: false) }
end
