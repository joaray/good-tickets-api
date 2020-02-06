class EventSerializer < ActiveModel::Serializer
  attributes %i[id
                name
                category
                place
                start_time
                ticket_price
                max_ticket_quantity
                sold_ticket_quantity
                available_ticket_quantity
                ticket_start_time
                ticket_end_time]
  has_one :organizer
end
