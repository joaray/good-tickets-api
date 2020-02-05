require 'rails_helper'

RSpec.describe Event, type: :model do

  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  it 'is invalid without a name' do
    event = build(:event, name: nil)
    event.valid?
    expect(event.errors[:name]).to include("can't be blank")
  end

  it 'is invalid with a duplicate name' do
    event = build(:event, name: create(:event).name)
    event.valid?
    expect(event.errors[:name]).to include('has already been taken')
  end

  it 'is invalid with a name with wrong format' do
    event = build(:event, name: 'a')
    event.valid?
    expect(event.errors[:name]).to include('is too short (minimum is 3 characters)')
  end

  it 'is invalid without a start time' do
    event = build(:event, start_time: nil)
    event.valid?
    expect(event.errors[:start_time]).to include("can't be blank")
  end
end
