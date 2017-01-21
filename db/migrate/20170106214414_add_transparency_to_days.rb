class AddTransparencyToDays < ActiveRecord::Migration
  def change
    add_column :days, :transparency, :decimal, precision: 2, scale: 2
  end
end
