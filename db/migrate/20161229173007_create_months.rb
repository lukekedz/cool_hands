class CreateMonths < ActiveRecord::Migration
  def change
    create_table :months do |t|
      t.string  :name,   null: false
      t.integer :length, null: false

      t.timestamps null: false
    end
  end
end
