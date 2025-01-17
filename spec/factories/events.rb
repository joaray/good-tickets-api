FactoryBot.define do
  factory :event do
    organizer { create(:user) }
    sequence(:name)      { |n| "event#{n}" }
    category             { 'concert' }
    place                { FFaker::Address.city }
    start_time           { Time.now + 21.days }
    ticket_price         { 25.99 }
    max_ticket_quantity  { 100 }
    ticket_start_time    { Time.now - 1.day }
    ticket_end_time      { Time.now + 20.days }
    sold_ticket_quantity { 20 }

    factory :inactive_event do
      start_time           { Time.now - 1.day }
      ticket_start_time    { Time.now - 20.days }
      ticket_end_time      { Time.now - 2.days }
      sold_ticket_quantity { 50 }
    end
  end
end
