# == Schema Information
#
# Table name: events
#
#  id                :integer          not null, primary key
#  event_type_id     :integer
#  name              :string(255)      not null
#  event_type        :integer          default("unknown_event")
#  series_name       :string(255)
#  started_at        :datetime         not null
#  ended_at          :datetime         not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  records_available :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :event do
    sequence(:name) { |n| "大成！プラチナスターライブ#{n}TH" }
    event_type 'psl_event'
    series_name nil
    sequence(:started_at) { |n| Time.parse('2020-01-16 17:00:00 +0900') + (n * 2).days }
    ended_at { started_at.nil? ? Time.now : ( started_at + 1.day ) }
  end
end
