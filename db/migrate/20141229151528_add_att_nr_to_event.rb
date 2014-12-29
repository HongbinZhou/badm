class AddAttNrToEvent < ActiveRecord::Migration
  def change
    add_column :events, :att_nr, :integer
  end
end
