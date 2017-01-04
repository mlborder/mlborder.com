class Alarm < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: %i(status_invalid status_valid)
  enum target: %i(target_undefined target_border)
end
