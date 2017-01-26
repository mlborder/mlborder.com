# == Schema Information
#
# Table name: alarms
#
#  id         :integer          not null, primary key
#  event_id   :integer          not null
#  user_id    :integer          not null
#  status     :integer          default("status_invalid"), not null
#  target     :integer          not null
#  rank       :integer          not null
#  value      :decimal(, )      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Alarm < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum status: %i(status_invalid status_valid)
  enum target: %i(target_undefined target_border)
end
