class Event < ApplicationRecord
  validates :name, presence: true, uniqueness: true, length: { minimum: 3, maximum: 50 }
  validates :start_time, presence: true, after_date: :ticket_end_time
  validates :ticket_price, presence: true, numericality: {
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100_000_000
  }
  validates :ticket_end_time, after_date: :ticket_start_time
  validates :max_ticket_quantity, :sold_ticket_quantity,
            presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :max_ticket_quantity,
            numericality: { greater_than_or_equal_to: :sold_ticket_quantity_or_zero }

  has_many :tickets

  def available_ticket_quantity
    max_ticket_quantity - sold_ticket_quantity
  end

  def sold_ticket_quantity_or_zero
    sold_ticket_quantity || 0
  end
end
