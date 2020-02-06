class Ticket < ApplicationRecord
  validates :quantity, presence: true,
                       numericality: { greater_than: 0,
                                       less_than_or_equal_to: :event_available_ticket_quantity }

  belongs_to :event
  belongs_to :customer, class_name: :User, foreign_key: :customer_id

  after_save :update_sold_ticket_quantity

  def update_sold_ticket_quantity
    event.sold_ticket_quantity += quantity
    event.save!
  end

  def event_available_ticket_quantity
    event.available_ticket_quantity
  end
end
