FactoryGirl.define do
  factory :event do
    event_type_id 1
    name '大成！プラチナスターライブ4TH'
    series_name nil
    sequence(:started_at) { |n| Time.parse('2015-01-16 17:00:00 +0900') + ((n - 1) * 12).days }
    sequence(:ended_at) { |n| Time.parse('2015-01-27 23:59:59 +0900') + ((n - 1) * 12).days }
  end
end
