# == Schema Information
#
# Table name: event_prizes
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  idol_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Event::Prize < ApplicationRecord
  belongs_to :event

  validates :idol_id, presence: true
end
