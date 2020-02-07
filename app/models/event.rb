class Event < ApplicationRecord
  PROTECTED_ATTRIBUTES = %w[place start_time ticket_price].freeze

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
  belongs_to :organizer, class_name: :User, foreign_key: :organizer_id

  before_destroy :prevent_destroy, if: :active?
  before_update :prevent_update, if: :active?

  def available_ticket_quantity
    max_ticket_quantity - sold_ticket_quantity
  end

  def sold_ticket_quantity_or_zero
    sold_ticket_quantity || 0
  end

  def active?
    start_time > Time.now && sold_ticket_quantity.positive?
  end

  def prevent_destroy
    throw(:abort)
  end

  def prevent_update
    throw(:abort) unless (changed & PROTECTED_ATTRIBUTES).empty?
  end

  def tickets_started?
    ticket_start_time && ticket_start_time <= Time.now
  end

  def tickets_ended?
    ticket_end_time && ticket_end_time <= Time.now
  end

  def tickets_active?
    tickets_started? && !tickets_ended? && max_ticket_quantity.positive?
  end
end
