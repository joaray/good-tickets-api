class TicketSerializer < ActiveModel::Serializer
  attributes :id, :quantity
  has_one :event
  has_one :customer
end
