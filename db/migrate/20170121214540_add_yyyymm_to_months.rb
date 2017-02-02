class AddYyyymmToMonths < ActiveRecord::Migration
  def change
    add_column :months, :yyyymm, :string
  end
end
