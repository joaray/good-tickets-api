class AddUserToTickets < ActiveRecord::Migration[6.0]
  def change
    add_reference :tickets, :customer, references: :users, null: false
    add_foreign_key :tickets, :users, column: :customer_id
  end
end
