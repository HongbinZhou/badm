class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.date :date
      t.string :place
      t.float :cost_total
      t.float :cost_per_person

      t.timestamps
    end
  end
end
