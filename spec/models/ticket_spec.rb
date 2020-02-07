require 'rails_helper'

RSpec.describe Ticket, type: :model do

  it 'has a valid factory' do
    expect(build(:ticket)).to be_valid
  end

  it 'is invalid without a quantity' do
    ticket = build(:ticket, quantity: nil)
    ticket.valid?
    expect(ticket.errors[:quantity]).to include("can't be blank")
  end

  it 'is invalid with a quantity less than 0' do
    ticket = build(:ticket, quantity: -2)
    ticket.valid?
    expect(ticket.errors[:quantity]).to include('must be greater than 0')
  end

  it 'is invalid with a quantity more than event_available_ticket_quantity' do
    ticket = build(:ticket, quantity: 200)
    ticket.valid?
    expect(ticket.errors[:quantity]).to include('must be less than or equal to 80')
  end

  it 'updates sold ticket quantity after save' do
    ticket = build(:ticket)
    expect{ ticket.save }.to change{ticket.event.sold_ticket_quantity}.by ticket.quantity
  end
end
