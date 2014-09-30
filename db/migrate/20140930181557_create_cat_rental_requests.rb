class CreateCatRentalRequests < ActiveRecord::Migration
  def change
    create_table :cat_rental_requests do |t|
      t.references :cat, index: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.string :status, default: "PENDING"

      t.timestamps
    end
  end
end
