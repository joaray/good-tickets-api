class AddTicketInfoToEvents < ActiveRecord::Migration[6.0]
  def change
    add_column :events, :ticket_price, :decimal, null: false
    add_column :events, :max_ticket_quantity, :integer, null: false, default: 0
    add_column :events, :sold_ticket_quantity, :integer, null: false, default: 0
    add_column :events, :ticket_start_time, :datetime
    add_column :events, :ticket_end_time, :datetime
  end
end
