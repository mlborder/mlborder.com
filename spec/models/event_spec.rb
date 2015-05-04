require 'rails_helper'

describe Event do
  it 'should have proper factory' do
    expect(build(:event)).to be_valid
  end
end
