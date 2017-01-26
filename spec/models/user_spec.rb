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

require 'rails_helper'

RSpec.describe User, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
