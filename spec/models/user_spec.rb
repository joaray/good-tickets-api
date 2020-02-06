require 'rails_helper'

RSpec.describe User, type: :model do

  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  it 'is invalid without an email' do
    user = build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it 'is invalid without a password' do
    user = build(:user, password: nil)
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it 'is invalid with a password shorter than 6' do
    user = build(:user, password: '123')
    user.valid?
    expect(user.errors[:password]).to include('is too short (minimum is 6 characters)')
  end

  it 'is invalid with a password longer than 128' do
    long_pass = 'a' * 129
    user = build(:user, password: long_pass)
    user.valid?
    expect(user.errors[:password]).to include('is too long (maximum is 128 characters)')
  end
end
