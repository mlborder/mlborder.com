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

FactoryGirl.define do
  factory :alarm do
    
  end

end
