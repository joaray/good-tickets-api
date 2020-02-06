class TicketSerializer < ActiveModel::Serializer
  attributes :id, :quantity
  has_one :event
end
