# == Schema Information
#
# Table name: users
#
#  id          :integer          not null, primary key
#  provider    :string           not null
#  uid         :string           not null
#  screen_name :string           not null
#  name        :string           not null
#  role        :integer          default("role_none"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class User < ApplicationRecord
  has_many :alarms
  has_one :profile, class_name: 'User::Profile'

  enum role: %i(role_none role_admin)

  def event_grouped_alarms
    alarms.order(id: :desc).includes(:event).group_by(&:event)
  end

  def self.create_with_omniauth(auth)
    create! do |user|
      user.provider = auth["provider"]
      user.uid = auth["uid"]
      user.name = auth["info"]["name"]
      user.screen_name = auth["info"]["nickname"]
    end
  end
end
