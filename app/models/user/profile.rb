# == Schema Information
#
# Table name: user_profiles
#
#  id              :integer          not null, primary key
#  user_id         :integer          not null
#  player_id       :string
#  produce_idol_id :integer
#  description     :text
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_user_profiles_on_produce_idol_id  (produce_idol_id) UNIQUE
#  index_user_profiles_on_user_id          (user_id) UNIQUE
#

class User::Profile < ApplicationRecord
end
