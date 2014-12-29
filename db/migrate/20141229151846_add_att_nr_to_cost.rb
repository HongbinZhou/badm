class AddAttNrToCost < ActiveRecord::Migration
  def change
    add_column :costs, :att_nr, :integer
  end
end
