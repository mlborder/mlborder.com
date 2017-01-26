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

FactoryGirl.define do
  factory :event_prize, :class => 'Event::Prize' do
    event_id 1
    idol_id 1
  end
end
