class RemoveTransparencyFromDays < ActiveRecord::Migration
  def change
    remove_column :days, :transparency, :decimal
  end
end
