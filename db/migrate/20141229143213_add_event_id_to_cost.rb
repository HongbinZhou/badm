class AddEventIdToCost < ActiveRecord::Migration
  def change
    add_column :costs, :event_id, :integer
  end
end
