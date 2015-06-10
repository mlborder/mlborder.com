FactoryGirl.define do
  factory :event do
    name '大成！プラチナスターライブ4TH'
    event_type 'psl_event'
    series_name nil
    sequence(:started_at) { |n| Time.parse('2020-01-16 17:00:00 +0900') + (n * 2).days }
    ended_at { started_at.nil? ? Time.now : ( started_at + 1.day ) }
  end
end
