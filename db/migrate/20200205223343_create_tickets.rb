class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.references :event, null: false
      t.integer :quantity, null: false
    end
  end
end
