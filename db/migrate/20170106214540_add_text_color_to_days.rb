class AddTextColorToDays < ActiveRecord::Migration
  def change
    add_column :days, :text_color, :string
  end
end
