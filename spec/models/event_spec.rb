require 'rails_helper'

RSpec.describe Event, type: :model do

  it 'has a valid factory' do
    expect(build(:event)).to be_valid
  end

  it 'is invalid without an organizer' do
    event = build(:event, organizer: nil)
    event.valid?
    expect(event.errors[:organizer]).to include('must exist')
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

  it 'is invalid with a ticket start time after event start time or ticket end time' do
    event = build(:event, ticket_start_time: Time.now + 2.month)
    event.valid?
    expect(event.errors[:ticket_end_time]).to include("can't be before ticket_start_time")
  end

  it 'is invalid with a ticket end time after event start time' do
    event = build(:event, ticket_end_time: Time.now + 2.month)
    event.valid?
    expect(event.errors[:start_time]).to include("can't be before ticket_end_time")
  end

  it 'is invalid without a ticket price' do
    event = build(:event, ticket_price: nil)
    event.valid?
    expect(event.errors[:ticket_price]).to include("can't be blank")
  end

  it 'is invalid with a ticket price less than 0' do
    event = build(:event, ticket_price: -5)
    event.valid?
    expect(event.errors[:ticket_price]).to include('must be greater than or equal to 0')
  end

  it 'is invalid with a ticket price greater than 100_000_000' do
    event = build(:event, ticket_price: 100_000_001)
    event.valid?
    expect(event.errors[:ticket_price]).to include('must be less than or equal to 100000000')
  end

  it 'is invalid without a max ticket quantity' do
    event = build(:event, max_ticket_quantity: nil)
    event.valid?
    expect(event.errors[:max_ticket_quantity]).to include("can't be blank")
  end

  it 'is invalid with a max ticket quantity less than 0' do
    event = build(:event, max_ticket_quantity: -5)
    event.valid?
    expect(event.errors[:max_ticket_quantity]).to include('must be greater than or equal to 0')
  end

  it 'is invalid with a max ticket quantity less than sold ticket quantity' do
    event = build(:event, sold_ticket_quantity: 105)
    event.valid?
    expect(event.errors[:max_ticket_quantity]).to include('must be greater than or equal to 105')
  end

  it 'is invalid without a sold ticket quantity' do
    event = build(:event, sold_ticket_quantity: nil)
    event.valid?
    expect(event.errors[:sold_ticket_quantity]).to include("can't be blank")
  end

  it 'is invalid with a sold ticket quantity less than 0' do
    event = build(:event, sold_ticket_quantity: -5)
    event.valid?
    expect(event.errors[:sold_ticket_quantity]).to include('must be greater than or equal to 0')
  end
end
