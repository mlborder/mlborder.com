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

require 'rails_helper'

RSpec.describe Event::Prize, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
