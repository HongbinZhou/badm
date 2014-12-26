class AddPayerIdToEvents < ActiveRecord::Migration
  def change
    add_column :events, :payer_id, :integer
  end
end
