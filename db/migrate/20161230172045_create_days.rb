class CreateDays < ActiveRecord::Migration
  def change
    create_table :days do |t|
      t.belongs_to :month,     null: false
      t.integer    :row,       null: false
      t.integer    :block,     null: false
      t.boolean    :clickable, null: false
      t.date       :date
      t.boolean    :practiced, null: false
      t.integer    :minutes
      t.integer    :streak

      t.timestamps null: false
    end
  end
end
