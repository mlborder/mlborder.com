# == Schema Information
#
# Table name: event_final_borders
#
#  id         :integer          not null, primary key
#  event_id   :integer
#  rank       :integer          default(1200), not null
#  point      :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :event_final_border, :class => 'Event::FinalBorder' do
    event_id 1
    rank 1
    point 1
  end
end
