require 'rails_helper'

describe EventType do
  it 'should have proper factory' do
    expect(build(:event_type)).to be_valid
  end
end
