class ActivityLog < ApplicationRecord
  belongs_to :assistant
  belongs_to :baby
  belongs_to :activity
end