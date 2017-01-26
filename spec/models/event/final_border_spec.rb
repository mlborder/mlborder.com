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

require 'rails_helper'

RSpec.describe Event::FinalBorder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
