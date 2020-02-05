class CreateEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :category
      t.string :place
      t.datetime :start_time, null: false

      t.timestamps
    end
  end
end
