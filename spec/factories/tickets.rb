FactoryBot.define do
  factory :ticket do
    customer { create(:user) }
    event
    quantity { 5 }
  end
end
