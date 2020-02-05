FactoryBot.define do
  factory :event do
    sequence(:name) { |n| "event#{n}" }
    category        { 'concert' }
    place           { FFaker::Address.city }
    start_time      { '2020-03-20 19:00:00' }
  end
end
